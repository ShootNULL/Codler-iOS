//
//  DI.swift
//  Codler
//
//  Created by Евгений Парфененков on 11.07.2023.
//

import Foundation
import Swinject

protocol DIProtocol {
    
    func getAppleID() -> AppleID
    func getData() -> Auth
    
    func getLoginViewController() -> LoginViewController
    func getLoginViewPresenter() -> LoginViewPresenter
    
    func getMainViewController() -> MainViewController
    func getMainViewPresenter() -> MainViewPresenter
    
    func getRegisterViewController() -> RegisterViewController
    func getRegisterViewPresenter() -> RegisterViewPresenter
}

class DI: DIProtocol {
    
    static let shared = DI()
    
    private let container: Container = {
        let container = Container()

        //container.register(AppleID.self) { _ in return AppleID() }
        container.register(Auth.self) { _ in return Auth() }
        
        container.register(LoginViewController.self) { _ in return LoginViewController() }
        container.register(LoginViewPresenter.self) { _ in return LoginViewPresenter() }
        
        container.register(MainViewController.self) { _ in return MainViewController() }
        container.register(MainViewPresenter.self) { _ in return MainViewPresenter() }
        
        container.register(RegisterViewController.self) { _ in return RegisterViewController() }
        container.register(RegisterViewPresenter.self) { _ in return RegisterViewPresenter() }

        return container
    }()
    
    private let appleID = AppleID()
    
    func getAppleID() -> AppleID { return container.resolve(AppleID.self)! }
    func getData() -> Auth { return container.resolve(Auth.self)! }
    
    func getLoginViewController() -> LoginViewController { return container.resolve(LoginViewController.self)! }
    func getLoginViewPresenter() -> LoginViewPresenter { return container.resolve(LoginViewPresenter.self)! }
    
    func getMainViewController() -> MainViewController { return container.resolve(MainViewController.self)! }
    func getMainViewPresenter() -> MainViewPresenter { return container.resolve(MainViewPresenter.self)! }
    
    func getRegisterViewController() -> RegisterViewController { return container.resolve(RegisterViewController.self)! }
    func getRegisterViewPresenter() -> RegisterViewPresenter { return container.resolve(RegisterViewPresenter.self)! }
    
}
