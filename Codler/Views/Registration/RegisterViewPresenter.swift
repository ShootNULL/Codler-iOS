//
//  RegisterViewPresenter.swift
//  Codler
//
//  Created by Евгений Парфененков on 28.10.2023.
//

import Foundation
import UIKit

protocol RegisterViewProtocol {
    
}

class RegisterViewPresenter: RegisterViewProtocol {
    
    func loadResult(result: Result) {
        let viewController = DI.shared.getRegisterViewController()
        switch result {
        case .allGood:
            DispatchQueue.main.async {
                let tabBarController = TabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                UIApplication.topViewController()?.present(tabBarController, animated: true)
            }
        case Result.serverError:
            let alert = UIAlertController(title: "Что-то не так...", message: "В настоящее время мы чиним наши сервера", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: {_ in
                exit(1)
            }))
            UIApplication.topViewController()?.present(alert, animated: true)
        case .nameNotUnique:
            viewController.hideLoading()
            viewController.showAlert(type: 0)
            print("name not unique")
        case .emailNotUnique:
            viewController.hideLoading()
            viewController.showAlert(type: 1)
            print("email not unique")

        }
    }
    
    enum Result {
        case allGood
        case serverError
        case nameNotUnique
        case emailNotUnique
    }
    
}
