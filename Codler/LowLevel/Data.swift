//
//  Data.swift
//  Codler
//
//  Created by Евгений Парфененков on 09.08.2023.
//

import Foundation

protocol AuthProtocol {
//    func getUserID() -> String?
//    func getUserToken() -> String?
//
//    func setUserID(id: String)
//    func setUserToken(token: String)
    
    func checkInit(appleId: String)
}

class Auth: AuthProtocol {
    
    func getSecret(key: String) -> String? {
        var secret: String? = nil

        let keychainItemIdToken = [kSecClass: kSecClassGenericPassword, kSecReturnAttributes: true,
                              kSecReturnData: true, kSecAttrAccount: key] as [CFString : Any] as CFDictionary
        var refIdToken: AnyObject?
        _ = SecItemCopyMatching(keychainItemIdToken, &refIdToken)
        if let result = refIdToken as? NSDictionary, let passwordData = result[kSecValueData] as? Data {
            let str = String(decoding: passwordData, as: UTF8.self)
            secret = str
        }
        
        return secret
    }

    func setSecret(key: String, value: String) {
        SecItemDelete([kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as [CFString : Any] as CFDictionary)
        SecItemAdd([kSecValueData: value.data(using: .utf8) ?? "", kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as [CFString : Any] as CFDictionary, nil)
    }
    
    func clearSecret(key: String) {
        SecItemDelete([kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as [CFString : Any] as CFDictionary)
    }
    
    func checkInit(appleId: String) {
        let loginViewPresenter = DI.shared.getLoginViewPresenter()
        
        let version = Bundle.main.buildVersionNumber ?? "0"
        
        DispatchQueue.background(background: {

            let url = URL(string: "http://82.146.33.253:8000/api/login?apple_id=" + appleId + "&device=ios&v=" + version)!
            print(url)
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                let stringData = String(data: data, encoding: .utf8)!
                DispatchQueue.main.sync(execute: {
                    switch statusCode {
                    case 200:
                        self.loadUserData(data: data)
                        loginViewPresenter.loadResult(result: LoginViewPresenter.Result.allGood)
                    case 403:
                        loginViewPresenter.loadResult(result: LoginViewPresenter.Result.lowVersion)
                    case 401:
                        loginViewPresenter.loadResult(result: LoginViewPresenter.Result.userLoginFail)
                    case 405:
                        loginViewPresenter.loadResult(result: LoginViewPresenter.Result.serverDown)
                    default:
                        loginViewPresenter.loadResult(result: LoginViewPresenter.Result.serverError)
                    }
                })
                
            }

            task.resume()
            
        })
    }
    
    func register(appleId: String, name: String, email: String, specialization: String) {
        let registerViewPresenter = DI.shared.getRegisterViewPresenter()
        
        DispatchQueue.background(background: {
            
            let defaultURL = "http://82.146.33.253:8000/api/register?apple_id=" + appleId + "&name="
            
            let url = URL(string: defaultURL + name + "&email=" + email + "&specialization=" + specialization)!
            print(url)
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                let stringData = String(data: data, encoding: .utf8)!
                DispatchQueue.main.sync(execute: {
                    switch statusCode {
                    case 200:
                        self.loadUserData(data: data)
                        registerViewPresenter.loadResult(result: RegisterViewPresenter.Result.allGood)
                    case 406:
                        print(406)
                        registerViewPresenter.loadResult(result: RegisterViewPresenter.Result.emailNotUnique)
                        
                    case 407:
                        print(407)
                        registerViewPresenter.loadResult(result: RegisterViewPresenter.Result.nameNotUnique)
                    default:
                        print("error")
                        registerViewPresenter.loadResult(result: RegisterViewPresenter.Result.serverError)
                    }
                })
                
            }

            task.resume()
            
        })
    }
    
    private func loadUserData(data: Data) {
        let decoder = JSONDecoder()
        
        if let jsonData = try? decoder.decode(User.self, from: data) {
            
            setSecret(key: "id", value: String(jsonData.id))
            setSecret(key: "appleId", value: jsonData.appleId)
            setSecret(key: "name", value: jsonData.name)
            setSecret(key: "email", value: jsonData.email)
            setSecret(key: "rating", value: String(jsonData.rating))
            setSecret(key: "role", value: jsonData.role)
            setSecret(key: "specialization", value: jsonData.specialization)
        }
    }
    
}

struct User: Codable {
    let id: Int
    let appleId: String
    let name: String
    let email: String
    let rating: Int
    let role: String
    let specialization: String
}
