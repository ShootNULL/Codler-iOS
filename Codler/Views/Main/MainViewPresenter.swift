//
//  MainViewPresenter.swift
//  Codler
//
//  Created by Евгений Парфененков on 14.07.2023.
//

import Foundation
import UIKit


protocol MainViewProtocol {
    
}

class MainViewPresenter: MainViewProtocol {
    
    let data = DI.shared.getData()
    
    func changeIcon() {
        if data.getSecret(key: "role") == "1" && UIApplication.shared.alternateIconName != "AppIconPrem" {
            UIApplication.shared.setAlternateIconName("AppIconPrem")
        } else if data.getSecret(key: "role") == "3" && UIApplication.shared.alternateIconName != "AppIconAdmin"{
            UIApplication.shared.setAlternateIconName("AppIconAdmin")
        } else if UIApplication.shared.alternateIconName != nil && data.getSecret(key: "role") == "0" {
            UIApplication.shared.setAlternateIconName(nil)
        }
        
    }
}
