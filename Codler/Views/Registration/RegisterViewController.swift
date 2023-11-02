//
//  RegisterViewController.swift
//  Codler
//
//  Created by Евгений Парфененков on 28.10.2023.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
    let logo = UIImageView()
    let fields = RegisterComponents.RegisterField()
    let specializations = RegisterComponents.Specializations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        view.backgroundColor = UIColor(hex: "#151417FF")
        
        addLogo()
        addFields()
        addSpecializations()
        
        addGestures()
    }
    
    private func addLogo() {
        logo.image = UIImage(named: "ImageShortLogo")
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        let logoConstraints = [
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 70),
            logo.heightAnchor.constraint(equalToConstant: 70),
        ]
        
        view.addSubview(logo)
        
        NSLayoutConstraint.activate(logoConstraints)
    }
    
    private func addFields() {
        fields.translatesAutoresizingMaskIntoConstraints = false
        
        let fieldsConstraints = [
            fields.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50),
            fields.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            fields.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            fields.heightAnchor.constraint(equalToConstant: 390),
        ]
        
        view.addSubview(fields)
        
        NSLayoutConstraint.activate(fieldsConstraints)
        
        (fields.viewWithTag(80) as! UIButton ).addTarget(self, action: #selector(goToSpec), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
    }
    
    @objc func doneButtonTapped() {
            view.endEditing(true)
        }
    
    private func addSpecializations() {
        
        specializations.translatesAutoresizingMaskIntoConstraints = false
        
        let specializationsConstraints = [
            specializations.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            specializations.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width),
            specializations.rightAnchor.constraint(equalTo: view.rightAnchor, constant: view.frame.width),
            specializations.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ]
        
        view.addSubview(specializations)
        
        NSLayoutConstraint.activate(specializationsConstraints)
        
        (specializations.viewWithTag(40) as! UIButton).addTarget(self, action: #selector(registerTap), for: .touchUpInside)
    }
    
    @objc func goToSpec() {
        
        if fields.getFieldsData() == [] {
            let alert = UIAlertController(title: "Внимание", message: "Пожалуйста, заполните все поля", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if !isValidEmail(fields.getFieldsData()[1] ?? "") {
            let alert = UIAlertController(title: "Внимание", message: "Введите корректную почту", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if fields.getFieldsData()[0]?.count ?? 0 < 5 {
            let alert = UIAlertController(title: "Внимание", message: "Никнейм должен быть длинее 5 символов", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: { [self] in
                logo.transform = CGAffineTransform(translationX: -(logo.bounds.width * 4), y: 0)
                fields.transform = CGAffineTransform(translationX: -(fields.bounds.width * 4), y: 0)
            })
            UIView.animate(withDuration: 0.5, animations:  { [self] in
                specializations.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
            })
            switcher = !switcher
        }
    }
    
    @objc func registerTap() {
        let data = DI.shared.getData()
        
        let name = fields.getFieldsData()[0]
        let email = fields.getFieldsData()[1]
        let specialization = specializations.getChoice()
                
        self.showLoading()
        data.register(appleId: data.getSecret(key: "appleId") ?? "", name: name ?? "", email: email ?? "", specialization: specialization)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var switcher = false
    private func addGestures() {
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerDown.direction = .right
        
        self.view.addGestureRecognizer(swipeGestureRecognizerDown)
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        if switcher {
            UIView.animate(withDuration: 0.5, animations: { [self] in
                specializations.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
            })
            UIView.animate(withDuration: 0.5, animations:  { [self] in
                logo.transform = CGAffineTransform(translationX: 0, y: 0)
                fields.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            switcher = !switcher
        }
    }
    
    
    
    func showLoading() {
        let alert = UIAlertController(title: "Загрузка...", message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()

        alert.view.addSubview(activityIndicator)

        activityIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: -30).isActive = true

        self.present(alert, animated: true)
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
