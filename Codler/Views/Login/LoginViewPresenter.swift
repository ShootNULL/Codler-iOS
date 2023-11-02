//
//  LoginViewPresenter.swift
//  Codler
//
//  Created by Евгений Парфененков on 11.07.2023.
//

import Foundation
import AuthenticationServices

protocol LoginViewProtocol {

}

class LoginViewPresenter: LoginViewProtocol {
    
    let data = DI.shared.getData()
    
    func serverAuth() {
        let mainViewController = DI.shared.getMainViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        
//        UIApplication.topViewController()?.present(mainViewController, animated: true)
    }
    
    func loadResult(result: Result) {
        
        switch result {
        case .allGood:
            DispatchQueue.main.async {
                let tabBarController = TabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                UIApplication.topViewController()?.present(tabBarController, animated: true)
                print("her2")
            }
            
        case Result.lowVersion:
            let alert = UIAlertController(title: "Внимание", message: "Вам необходимо обновить приложение", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Обновить", style: .default, handler: {_ in
                exit(1)
            }))
            UIApplication.topViewController()?.present(alert, animated: true)
        case Result.serverError:
            let alert = UIAlertController(title: "Что-то не так...", message: "В настоящее время мы чиним наши сервера", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: {_ in
                exit(1)
            }))
            UIApplication.topViewController()?.present(alert, animated: true)
        case .serverDown:
            print("serverDown")
        case .userBlocked:
            print("User Blocked")
        case .userLoginFail:
            print("Go to register")
            
            DI.shared.getLoginViewController().hideLoading()
//            UIApplication.topViewController()?.present(DI.shared.getRegisterViewController(), animated: true)
            DI.shared.getLoginViewController().goToRegister()
            
            
        }
    }
    
    enum Result {
        case allGood
        case serverError
        case serverDown
        case lowVersion
        case userLoginFail
        case userBlocked
    }
}
