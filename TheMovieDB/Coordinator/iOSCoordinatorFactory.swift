//
//  iOSCoordinatorFactory.swift
//  TheMovieDB
//
//  Created by Sinuhé Ruedas on 12/10/22.
//

import UIKit

protocol ViewControllerFactory {
   func loginViewController() -> UIViewController
}

class iOSCoordinatorFactory: ViewControllerFactory {
   
   func loginViewController() -> UIViewController {
      let loginAPI: LoginAPI = LoginAPI(session: .shared)
      let loginViewController: LoginViewController = LoginViewController()
      let viewModel: LoginViewModel = LoginViewModel(api: loginAPI)
      loginViewController.viewModel = viewModel
      return loginViewController
   }
   
}
