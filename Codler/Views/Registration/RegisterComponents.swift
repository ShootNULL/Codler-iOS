//
//  RegisterComponents.swift
//  Codler
//
//  Created by Евгений Парфененков on 28.10.2023.
//

import Foundation
import UIKit

class RegisterComponents {
    
    final class RegisterField: UIView, UITextFieldDelegate {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setUp()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private let textRegister = UILabel()
        private let nameField = UITextField()
        private let emailField = UITextField()
        private let button = UIButton()
        
        func getFieldsData() -> [String?] {
            if nameField.text != nil && emailField.text != nil {
                return [nameField.text, emailField.text]
            } else { return [] }
        }
        
        private func setUp() {
            self.backgroundColor = UIColor(hex: "#0D0C0EFF")
            self.layer.cornerRadius = 40
            
            addTextRegister()
            addnameField()
            addEmailField()
            addButton()
            
            setUpToolBarNext()
        }
        
        private func addTextRegister() {
            textRegister.adjustsFontSizeToFitWidth = true
            textRegister.text = "Регистрация"
            textRegister.font = .bold(size: 100)
            textRegister.textAlignment = .center
            
            textRegister.translatesAutoresizingMaskIntoConstraints = false
            
            let textRegisterConstraints = [
                textRegister.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
                textRegister.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                textRegister.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45),
                textRegister.heightAnchor.constraint(equalToConstant: 60)
            ]
            
            self.addSubview(textRegister)
            
            NSLayoutConstraint.activate(textRegisterConstraints)
        }
        
        private func addnameField() {
            nameField.attributedPlaceholder = NSAttributedString(string:"Имя пользователя", attributes:[NSAttributedString.Key.font: UIFont.regular(size: 14)])
            nameField.typingAttributes = [NSAttributedString.Key.font: UIFont.bold(size: 18)]
            nameField.textAlignment = .justified
            nameField.keyboardType = .asciiCapable
            
            nameField.backgroundColor = UIColor(hex: "#1C1B1EFF")
            nameField.layer.cornerRadius = 25
            
            let spacerView = UIView(frame:CGRect(x:0, y:0, width:25, height:10))
            nameField.leftViewMode = .always
            nameField.leftView = spacerView
            
            
            nameField.translatesAutoresizingMaskIntoConstraints = false
            
            let nameFieldConstraints = [
                nameField.topAnchor.constraint(equalTo: textRegister.bottomAnchor, constant: 35),
                nameField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                nameField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
                nameField.heightAnchor.constraint(equalToConstant: 50)
            ]
            
            self.addSubview(nameField)
            
            NSLayoutConstraint.activate(nameFieldConstraints)
            
            nameField.addTarget(self, action: #selector(editingChangedName(_:)), for: .editingChanged)
            nameField.tag = 120
            nameField.delegate = self
        }
        
        private func addEmailField() {
            emailField.attributedPlaceholder = NSAttributedString(string:"E-mail", attributes:[NSAttributedString.Key.font: UIFont.regular(size: 14)])
            emailField.typingAttributes = [NSAttributedString.Key.font: UIFont.bold(size: 18)]
            emailField.textAlignment = .justified
            emailField.keyboardType = .emailAddress
            
            emailField.backgroundColor = UIColor(hex: "#1C1B1EFF")
            emailField.layer.cornerRadius = 25
            
            let spacerView = UIView(frame:CGRect(x:0, y:0, width:25, height:10))
            emailField.leftViewMode = .always
            emailField.leftView = spacerView
            
            
            emailField.translatesAutoresizingMaskIntoConstraints = false
            
            let emailFieldConstraints = [
                emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 15),
                emailField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                emailField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
                emailField.heightAnchor.constraint(equalToConstant: 50)
            ]
            
            self.addSubview(emailField)
            
            NSLayoutConstraint.activate(emailFieldConstraints)
            
            emailField.addTarget(self, action: #selector(editingChangedEmail(_:)), for: .editingChanged)
            emailField.tag = 130
            emailField.delegate = self
        }
        
        private func addButton() {
            button.backgroundColor = .white
            button.tintColor = .green
            button.layer.cornerRadius = 27
            button.setTitle("Далее", for: .normal)
            button.setTitleColor(UIColor(hex: "#040200FF"), for: .normal)
            button.tag = 80
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let buttonConstraints = [
                button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
                button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
                button.heightAnchor.constraint(equalToConstant: 55)
            ]
            
            self.addSubview(button)
            
            NSLayoutConstraint.activate(buttonConstraints)
            
            //emailField.addTarget(self, action: #selector(editingChangedEmail(_:)), for: .editingChanged)
            //emailField.addTarget(self, action: #selector(editingChangedEmail(_:)), for: .editingChanged)
        }
        
        @objc func editingChangedName(_ sender: Any) {
            if nameField.text?.count ?? 0 > 0 { nameField.font = .bold(size: 18) }
            else { nameField.attributedPlaceholder = NSAttributedString(string:"Имя пользователя", attributes:[NSAttributedString.Key.font: UIFont.regular(size: 14)]) }
        }
        
        @objc func editingChangedEmail(_ sender: Any) {
            if emailField.text?.count ?? 0 > 0 { emailField.font = .bold(size: 18) }
            else { emailField.attributedPlaceholder = NSAttributedString(string:"E-mail", attributes:[NSAttributedString.Key.font: UIFont.regular(size: 14)]) }
        }
        
        private func setUpToolBarNext() {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let donebutton = UIBarButtonItem(title: "Далее", style:   UIBarButtonItem.Style.done, target: self, action: #selector(self.nextClick))
            toolbar.setItems([donebutton], animated: false)
            nameField.inputAccessoryView = toolbar
            setUpToolBarDone()
        }
        
        private func setUpToolBarDone() {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let donebutton = UIBarButtonItem(title: "Готово", style:   UIBarButtonItem.Style.done, target: self, action: #selector(self.doneClick))
            toolbar.setItems([donebutton], animated: false)
            emailField.inputAccessoryView = toolbar
        }
        
        @objc func nextClick() { emailField.becomeFirstResponder() }
        @objc func doneClick() { self.endEditing(true) }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField.tag == 120 { emailField.becomeFirstResponder() }
            else { self.endEditing(true) }
            return false
        }
        
    }
    
    final class Specializations: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setUp()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private let label = UITextView()
        private let registerButton = UIButton()
        
        func getChoice() -> String { return String(currentChoice) }
        
        private var currentChoice = 0
                
        private func setUp() {
            self.backgroundColor = .clear

            addLabel()
            addButtons()
            addRegisterButton()
        }
        
        private func addLabel() {
            label.text = "Выбери свою \nспециальность"
            label.font = .bold(size: 26)
            label.textAlignment = .center
            label.backgroundColor = .clear
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let labelConstraints = [
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),
                label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
                label.heightAnchor.constraint(equalToConstant: 80)
            ]
            
            self.addSubview(label)
            
            NSLayoutConstraint.activate(labelConstraints)
        }
        
        private func addButtons() {
            let buttons = ["Back-end", "Front-end", "DevOps", "iOS", "Android"]
            
            var buttonCounter = 5
            buttons.forEach { text in
                let button = UIButton()
                
                button.setTitle(text, for: .normal)
                button.titleLabel?.font = .bold(size: 20)
                button.backgroundColor = UIColor(hex: "#1C1B1EFF")
                button.layer.cornerRadius = 30
                
                button.tag = buttonCounter
                button.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
                
                button.translatesAutoresizingMaskIntoConstraints = false
                
                let buttonConstraints = [
                    
                    buttonCounter == 5 ? button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 70) : button.topAnchor.constraint(equalTo: viewWithTag(buttonCounter - 1)!.bottomAnchor, constant: 15),
                    button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
                    button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
                    button.heightAnchor.constraint(equalToConstant: 60)
                ]
                
                self.addSubview(button)
                
                NSLayoutConstraint.activate(buttonConstraints)
                
                buttonCounter += 1
            }
        }
        
        @objc func btnClicked(_ sender: AnyObject?) {
            let button = sender as! UIButton
            
            for tag in 5...10 {
                self.viewWithTag(tag)?.layer.opacity = 0.4
                self.viewWithTag(tag)?.backgroundColor = UIColor(hex: "#1C1B1EFF")
            }
            UIView.animate(withDuration: 0.4, animations: {
                button.layer.opacity = 1
                button.backgroundColor = UIColor(hex: "#8E48EAFF")
            })
            
            currentChoice = button.tag - 5
            
            if registerButton.isHidden {
                registerButton.isHidden = false
                registerButton.fadeIn(0.5)
            }
        }
        
        private func addRegisterButton() {
            registerButton.setTitle("Зарегистрироваться", for: .normal)
            registerButton.titleLabel?.font = .bold(size: 16)
            registerButton.backgroundColor = UIColor(hex: "#F5F5FAFF")
            registerButton.layer.cornerRadius = 30
            registerButton.setTitleColor(UIColor(hex: "#040200FF"), for: .normal)
            registerButton.tag = 40
            
            registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
            
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            
            let registerButtonConstraints = [
                
                registerButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60),
                registerButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
                registerButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
                registerButton.heightAnchor.constraint(equalToConstant: 60)
            ]
            
            self.addSubview(registerButton)
            
            NSLayoutConstraint.activate(registerButtonConstraints)
            
            registerButton.isHidden = true
        }
        
        @objc func registerTap() {

        }
    }
    
}
