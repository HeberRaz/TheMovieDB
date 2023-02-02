//
//  LoginAPI.swift
//  TheMovieDB
//
//  Created by Sinuhé Ruedas on 12/10/22.
//

import Foundation

struct LoginAPI {
    typealias LoginResult = Result<LoginResponse, Error>
   let session: URLSession
   
   func send(_ endpoint: Endpoint, userLoginData: UserLoginData, completion: @escaping (LoginResult) -> Void) {
      var request = endpoint.request
         
      request.httpMethod = HTTPMethod.POST.rawValue
      let parameters: [String: Any] = [
         "username": userLoginData.username ?? "",
         "password": userLoginData.password ?? "",
         "request_token": Credentials.requestToken
      ]
      
      
   request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
   request.setValue("application/json", forHTTPHeaderField: "Accept")
   request.httpMethod = "POST"
   request.httpBody = parameters.percentEncoded()
      
      session.dataTask(with: request) { data, response, error in
          guard hasNo(error: error, completion: completion) else { return }
          guard isValid(response: response, completion: completion) else { return }
          validate(data: data, completion: completion)
      }.resume()
   }
    
    // MARK: - Private methods
    
    private func hasNo(error: Error?, completion: (LoginResult) -> Void) -> Bool {
        if let error: Error = error {
            debugPrint("error", error)
            completion(.failure(error))
            return false
        }
        return true
    }
    
    private func isValid(response: URLResponse?, completion: (LoginResult) -> Void) -> Bool {
        guard let response: HTTPURLResponse = response as? HTTPURLResponse else {
            completion(.failure(APIError.response))
            return false
        }
        
        guard (200 ... 299) ~= response.statusCode else {
            print("statusCode should be 2xx, but is \(response.statusCode)")
            print("response = \(response)")
            completion(.failure(APIError.internalServer))
            return false
        }
        return true
    }
    
    private func validate(data: Data?, completion: (LoginResult) -> Void) {
        guard let data: Data = data else {
            completion(.failure(APIError.noData))
            return
        }

        do {
            let getPlaces: LoginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            completion(.success(getPlaces))
        } catch {
            completion(.failure(APIError.parsingData))
        }
    }
}

extension Dictionary {
  func percentEncoded() -> Data? {
    map { key, value in
      let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      return escapedKey + "=" + escapedValue
    }
    .joined(separator: "&")
    .data(using: .utf8)
  }
}

extension CharacterSet {
  static let urlQueryValueAllowed: CharacterSet = {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="

    var allowed: CharacterSet = .urlQueryAllowed
    allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    return allowed
  }()
}

