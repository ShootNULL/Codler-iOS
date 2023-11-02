//
//  AppleID.swift
//  Codler
//
//  Created by Евгений Парфененков on 13.07.2023.
//

import Foundation
import AuthenticationServices

class AppleID: NSObject, ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        print("ZHOPAAA")
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    
            let userId = appleIDCredential.user
            let email = appleIDCredential.email ?? ""
            
            
            
        }
        
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        print("ZHOPAAA")
    }
    
}
