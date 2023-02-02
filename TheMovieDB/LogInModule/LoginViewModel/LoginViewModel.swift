//
//  LoginViewModel.swift
//  TheMovieDB
//
//  Created by Sinuhé Ruedas on 12/10/22.
//

import Foundation

protocol LoginStatus: AnyObject {
    func successful()
    func denied()
}

final class LoginViewModel {
   var userLoginData: UserLoginData?
   var api: LoginAPI
//   @ViewModelState var state: APIState?
    weak var delegate: LoginStatus?
    var loginStatus: Bool? {
        didSet {
            if loginStatus ?? false {
                delegate?.successful()
            } else {
                delegate?.denied()
            }
        }
    }
   var errorMessage: String?
   
   init(api: LoginAPI) {
      self.api = api
   }

    func requestLoginAccess() {
        guard let loginData: UserLoginData = userLoginData else { return }
        api.send(.login, userLoginData: loginData) { [weak self] (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let loginResponse):
                self?.loginStatus = true
                print(loginResponse)
            case .failure(let error):
                let error = error as? APIError
                self?.loginStatus = false
                switch error {
                case .internalServer:
                    self?.errorMessage = "Invalid username and/or password. You did not provide a valid login."
                default:
                    self?.errorMessage = "Something went wrong"
                }
            }
        }
   }
}
