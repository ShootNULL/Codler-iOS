//
//  LoginViewController.swift
//  Codler
//
//  Created by Евгений Парфененков on 11.07.2023.
//

import Foundation
import UIKit
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    
//    private let presenter = DI.shared.getLoginViewPresenter()
    private let data = DI.shared.getData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private let button = MainComponents().buttonAppleSignIn()
    private let logo = UIImageView()
    
    
    private func setUp() {
        view.backgroundColor = UIColor(hex: "#151417FF")
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonConstraints = [
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            button.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        view.addSubview(button)
        NSLayoutConstraint.activate(buttonConstraints)
        
        button.addTarget(self, action: #selector(handle), for: .touchUpInside)
        
        setUpLogo()
        checkAccount()
    }
    
    private func setUpLogo() {
        logo.image = UIImage(named: "ImageLogoText")
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        let logoConstraints = [
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            logo.widthAnchor.constraint(equalToConstant: 139),
            logo.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        view.addSubview(logo)
        NSLayoutConstraint.activate(logoConstraints)
    }
    
    func goToRegister() {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(DI.shared.getRegisterViewController(), animated: true)
//            self.present(DI.shared.getRegisterViewController(), animated: true)
        }
    }
    
    @objc func handle() { singInAppleID() }
    
    private func checkAccount() {
        let appleId = data.getSecret(key: "appleId")
        if appleId == nil { hideLoading() }
        else { 
            showLoading()
            data.checkInit(appleId: appleId ?? "")
        }
    }
    
    func singInAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        print("REQUESTED")
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            guard let appleIDToken = appleIDCredential.identityToken else {
//                print("Unable to fetch identity token")
//                return
//            }
            
//            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                return
//            }
                    
            let userIdentifier = appleIDCredential.user
            data.setSecret(key: "appleId", value: userIdentifier)
            checkAccount()
            
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        let alert = UIAlertController(title: "Упс...", message: "Произошла ошибка при авторизации", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)

        switch error.code {
        case .canceled:
            print("Canceled")
        case .unknown:
            print("Unknown")
        case .invalidResponse:
            print("Invalid Respone")
        case .notHandled:
            print("Not handled")
        case .failed:
            print("Failed")
        case .notInteractive:
            print("Non-Interactive")
        @unknown default:
            print("Default")
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Загрузка...", message: nil, preferredStyle: .alert)
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.isUserInteractionEnabled = false
            activityIndicator.startAnimating()

            alert.view.addSubview(activityIndicator)

            activityIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 0).isActive = true
            activityIndicator.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: -30).isActive = true
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { UIApplication.topViewController()?.dismiss(animated: true) }
    }
    
    func showAlert(type: Int) {
        if type == 0 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: "Данный никнейм уже используется", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
        } else if type == 1 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: "Данная почта уже используется", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
}
