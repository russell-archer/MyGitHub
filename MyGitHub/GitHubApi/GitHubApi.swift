//
//  GitHubApi.swift
//  MyGitHub
//
//  Created by Russell Archer on 11/04/2021.
//

import AuthenticationServices
import SwiftUI


/// GitHubApi assumes you have previously defined an "OAuth App" in your GitHub account (Settings > Developer settings).
/// 
/// The OAuth app configuration defines a Client ID, Client Secret and Callback URL, which is used to pass data back to this app.
/// Use `authenticate(completion:)` to authenticate the user before attempting to use other methods to return private data.
class GitHubApi: NSObject {
    
    enum requestType { case profile, repos }
    
    /// Authenticate the user on GitHub and obtain the access and refresh tokens required to use the GitHub API with delegated access.
    ///
    /// We use `ASWebAuthenticationSession` to pass our Client ID (which identifies this app), client secret and callback URL
    /// scheme to GitHub. A GitHub authentication page is then presented to allow the user to authenticate. Once authenticated,
    /// GitHub passes back to us (using callback URL we defined on GitHub) an authorization code.
    ///
    /// We then make a request to GitHub to exchange the authorization code for the access and refresh tokens that allow
    /// this app to use GitHub API methods with "delegated access" (i.e. as if it were the authenticated user).
    /// - Parameter completion: A closure that takes a `Result<Authentication, ApiError>`. If successfully authenticated the
    /// the result will contain an `Authentication` with an access token that may be included with API calls to authorize access.
    /// See GitHub documentation: https://docs.github.com/en/developers/apps/authorizing-oauth-apps
    func authenticate(completion: @escaping (Result<Authentication, ApiError>) -> Void) {
        
        guard let authenticateUserUrl = buildRequestAuthenticationCodeUrl() else {
            completion(.failure(.badParams))
            return
        }
        
        // Allow the user to authenticate on GitHub and receive an authentication code back
        let session = ASWebAuthenticationSession(url: authenticateUserUrl, callbackURLScheme: Strings.callbackURLScheme) { [unowned self] callbackURL, error in
            
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.gitHubError)) }
                return
            }
            
            // GitHub returns the authentication code to us on the callback URL query string
            guard let authCode = extractAuthenticationCode(callbackUrl: callbackURL) else {
                DispatchQueue.main.async { completion(.failure(.badAuthenticationCode)) }
                return
            }
            
            // Request the access and refresh tokens
            requestAccessToken(authenticationCode: authCode) { result in
                
                switch(result) {
                    case .failure(let error):
                        DispatchQueue.main.async { completion(.failure(error)) }
                        return
                        
                    case .success(let authentication):
                        DispatchQueue.main.async { completion(.success(authentication)) }
                        return
                }
            }
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        
        guard session.start() else {
            completion(.failure(.cantStartSession))
            return
        }
    }
    
    /// Gets the currently authenticated user's GitHub profile.
    /// - Parameters:
    ///   - userAuthentication: An `Authentication` object that includes a GitHub access token.
    ///   - completion: A closure that will be called when the process is complete. The `Result` will be returned on the main thread.
    ///   If successful, the `Result` will contain the user's profile.
    func userProfile(userAuthentication: Authentication, completion: @escaping (Result<User, ApiError>) -> Void) {

        processRequest(type: .profile, userAuthentication: userAuthentication, completion: completion)
    }
    
    /// Get a list of the authenticated user's repos.
    /// - Parameters:
    ///   - userAuthentication: An `Authentication` object that includes a GitHub access token.
    ///   - completion: A closure that will be called when the process is complete. The `Result` will be returned on the main thread.
    ///   If successful, the `Result` will contain the user's repos.
    func repos(userAuthentication: Authentication, completion: @escaping (Result<[Repository], ApiError>) -> Void) {
        
        processRequest(type: .repos, userAuthentication: userAuthentication, completion: completion)
    }
    
    // MARK:- Private methods
    
    /// Request data via the GitHub API and decode the JSON data result.
    /// - Parameters:
    ///   - type: The type of request (e.g. get user profile data or list or repos).
    ///   - userAuthentication: An `Authentication` object that includes a GitHub access token.
    ///   - completion: A closure that will be called when the process is complete. The `Result` will be returned on the main thread.
    private func processRequest<T: Decodable>(type: requestType, userAuthentication: Authentication, completion: @escaping (Result<T, ApiError>) -> Void) {

        var requestUrl: URL?
        var decodeType: T.Type
        
        switch type {
            case .profile:
                decodeType = User.self as! T.Type
                requestUrl = buildRequestUserProfileUrl()
                
            case .repos:
                decodeType = [Repository].self as! T.Type
                requestUrl = buildRequestReposUrl(page: 1)
        }
        
        guard let url = requestUrl else {
            completion(.failure(.badParams))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Strings.httpGetMethodName
        
        // Get the cached access token (if it exists) and add it as an HTTP header
        if let accessToken = userAuthentication.accessToken {
            request.setValue("\(Strings.accessTokenRequestName) \(accessToken)", forHTTPHeaderField: Strings.authorizationHeaderName)
        } else {
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        // Make the request for data
        let task = URLSession.shared.dataTask(with: request) { json, response, error in
            
            // Was any data returned?
            guard json != nil else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            // Check the response from the server (200 == OK)
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async { completion(.failure(.badResponse)) }
                return
            }
            
            // Did GitHub report an error
            guard error == nil else {
                print("GitHub reports an error: \(error!.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(.badResponse)) }
                return
            }
            
            // Decode the data from JSON into the appropriate type
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let profile = try? decoder.decode(decodeType, from: json!) else {
                DispatchQueue.main.async { completion(.failure(.cantDecode)) }
                return
            }
                        
            // We got the data back from GitHub and successfully decoded it
            DispatchQueue.main.async { completion(.success(profile)) }
        }
        
        task.resume()  // Start the request task
    }
    
    /// Extract the GitHub authentication code from a URL.
    /// - Parameter callbackUrl: The URL that contains the authentication code.
    /// - Returns: Returns the extracted authentication code, or nil the code couldn't be located.
    private func extractAuthenticationCode(callbackUrl: URL?) -> String? {
        
        guard let cbUrl = callbackUrl,
              let queryItems = URLComponents(string: cbUrl.absoluteString)?.queryItems,
              let authCode = queryItems.first(where: { $0.name == Strings.accessCodeQueryItemName })?.value else {
            
            return nil
        }
        
        return authCode
    }
    
    /// Get the access token required by the GitHub API.
    /// - Parameters:
    ///   - authenticationCode: The code provided to us by GitHub when the user authenticated.
    ///   - completion: A closure that will be called when the process is complete.
    private func requestAccessToken(authenticationCode: String, completion: @escaping (Result<Authentication, ApiError>) -> Void) {
        guard let requestTokensUrl = buildRequestTokensUrl(authenticationCode: authenticationCode) else {
            completion(.failure(.badParams))
            return
        }
        
        // The request URL will be the form:
        // https://github.com/login/oauth/access_token?client_id=xxxxx&client_secret=xxxxx&code=xxxxx
        var request = URLRequest(url: requestTokensUrl)
        request.httpMethod = Strings.httpPostMethodName
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard data != nil else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            // Check the response from the server (200 == OK)
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async { completion(.failure(.badResponse)) }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.badResponse)) }
                return
            }
            
            guard let sResponse = String(data: data!, encoding: .utf8) else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            // Extract the tokens from the response query string which will be in the form:
            // access_token=gho_xxxx&scope=&token_type=bearer
            guard let authentication = self.extractTokens(response: sResponse) else {
                DispatchQueue.main.async { completion(.failure(.cantGetToken)) }
                return
            }
            
            // Success. We got the access token back from GitHub OK
            DispatchQueue.main.async { completion(.success(authentication)) }
        }
        
        task.resume()
    }
    
    /// Extract the access and refresh tokens from the GitHub response string.
    /// The tokens are also persisted to UserDefaults.
    /// The string is expected to be in the form: access_token=gho_xxxx&scope=&token_type=bearer
    /// - Parameter response: Response string returned by GitHub.
    /// - Returns: Returns an Authentication object containing the access token, or nil if the access token wasn't found.
    private func extractTokens(response: String) -> Authentication? {
        let authentication = Authentication()
        var foundAccessToken = false
        let queryItems = response.components(separatedBy: "&")
        
        for item in queryItems {
            let itemComponents = item.components(separatedBy: "=")
            if let key = itemComponents.first, let value = itemComponents.last {
                // If we find an access token or a refresh token then save it
                if key == Strings.accessTokenName {
                    authentication.accessToken = value
                    foundAccessToken = true
                }
                
                if key == Strings.refreshTokenName {
                    authentication.refreshToken = value
                }
            }
        }
        
        return foundAccessToken ? authentication : nil
    }
}

extension GitHubApi: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

