//
//  MainViewController.swift
//  Codler
//
//  Created by Евгений Парфененков on 14.07.2023.
//

import Foundation
import UIKit
import SkeletonView

class MainViewController: UIViewController {
    
    let data = DI.shared.getData()
        
    let mainText = UILabel()
    let smallProfile = MainComponents.SmallProfile(frame: CGRect(x: 10, y: 10, width: 1000, height: 200))
    let fastGame = MainComponents.FastGameButton(frame: CGRect(x: 10, y: 10, width: 1000, height: 200))
    let training = MainComponents.TrainingButton(frame: CGRect(x: 10, y: 10, width: 1000, height: 200))
    let gameModes = MainComponents.GameModesButton(frame: CGRect(x: 10, y: 10, width: 1000, height: 200))
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setUp()
    }
    
    private var pan = UIPanGestureRecognizer()
    
    private func setUp() {
        print("kek")
        view.backgroundColor = UIColor(named: "ColorDark") ?? .black
        
        setUpGameModes()
        setUpTraining()
        setUpFastGame()
        setUpProfile()
        setUpTextMain()
        
        setUpUpdater()
        
        DI.shared.getMainViewPresenter().changeIcon()
        
    }
    
    private func setUpTextMain() {
        mainText.adjustsFontSizeToFitWidth = true
        mainText.text = "Главная"
//        mainText.font = .medium(size: 100)
        mainText.font = .systemFont(ofSize: 100, weight: .medium)
        
        mainText.translatesAutoresizingMaskIntoConstraints = false
        
        let mainTextConstraints = [
            mainText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            mainText.bottomAnchor.constraint(equalTo: smallProfile.topAnchor, constant: 0),
            mainText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            mainText.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
//            mainText.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        view.addSubview(mainText)
        
        NSLayoutConstraint.activate(mainTextConstraints)
    }
    
    private func setUpProfile() {
        smallProfile.setImage(image: UIImage(named: "TemplateProfile") ?? .add)
        smallProfile.setName(name: data.getSecret(key: "name") ?? "")
        smallProfile.updateRating(rating: Int(data.getSecret(key: "rating") ?? "0")!)
        
        smallProfile.translatesAutoresizingMaskIntoConstraints = false
        
        let smallProfileConstraints = [
            smallProfile.bottomAnchor.constraint(equalTo: fastGame.topAnchor, constant: -15),
            smallProfile.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            smallProfile.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            smallProfile.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.24),
//            smallProfile.heightAnchor.constraint(equalToConstant: 220),
        ]
        
        view.addSubview(smallProfile)
        
        NSLayoutConstraint.activate(smallProfileConstraints)
    }
    
    private func setUpFastGame() {
        
        fastGame.translatesAutoresizingMaskIntoConstraints = false
        
        let smallProfileConstraints = [
            fastGame.bottomAnchor.constraint(equalTo: training.topAnchor, constant: -15),
            fastGame.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            fastGame.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            fastGame.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.21)
//            fastGame.heightAnchor.constraint(equalToConstant: 180)
        ]
        
        view.addSubview(fastGame)
        NSLayoutConstraint.activate(smallProfileConstraints)
    }
    
    private func setUpTraining() {
        training.translatesAutoresizingMaskIntoConstraints = false
        
        let trainingConstraints = [
            training.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            training.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            training.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            training.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22)
        ]
        
        view.addSubview(training)
        NSLayoutConstraint.activate(trainingConstraints)
    }
    
    private func setUpGameModes() {
        gameModes.translatesAutoresizingMaskIntoConstraints = false
        
        let gameModesConstraints = [
            gameModes.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            gameModes.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            gameModes.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            gameModes.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22)
        ]
        
        view.addSubview(gameModes)
        NSLayoutConstraint.activate(gameModesConstraints)
    }
    
    private func setUpUpdater() {
        pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) -> Bool {
        let velocity = sender.velocity(in: view)
        if abs(velocity.y) < abs(velocity.x) || velocity.y < 0 {
                return false
            }
        
        let translation = sender.translation(in: view)

        var counter = 1
        var isSecond = false
        view.subviews.reversed().forEach { subview in
            subview.transform = CGAffineTransform(translationX: 0, y: translation.y * CGFloat(counter) * 0.1)
            if !isSecond && counter == 4 {
                counter -= 1
                isSecond = !isSecond
            }
            counter += 1
        }
        
        if translation.y > 250  && sender.state == .ended {
            print("Запустить обновление")
            
//            view.removeGestureRecognizer(pan)
            UIView.animate(withDuration: 0.25, animations: {
                self.view.subviews.reversed().forEach { subview in
                    subview.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }) { [self] _ in
                self.view.showLoader()
                self.data.updateInfo(appleId: self.data.getSecret(key: "appleId") ?? "")
            }
            
        } else if sender.state == .ended {
            view.removeGestureRecognizer(pan)
            UIView.animate(withDuration: 0.25, animations: {
                self.view.subviews.reversed().forEach { subview in
                    subview.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }) { _ in
                self.view.addGestureRecognizer(self.pan)
            }
        }
        
        return true
    }
    
    func finishUpdate() {
        DispatchQueue.main.async { [self] in
            UIApplication.topViewController()?.view.subviews.forEach { subview in
                if type(of: subview) == MainComponents.SmallProfile.self {
                    let tempView = subview as! MainComponents.SmallProfile
                    tempView.setImage(image: UIImage(named: "TemplateProfile") ?? .add)
                    tempView.setName(name: data.getSecret(key: "name") ?? "")
                    tempView.updateRating(rating: Int(data.getSecret(key: "rating") ?? "0")!)
                }
            }
        }
        
        print(data.getSecret(key: "rating") ?? "0")
        
        self.view.removeLoader()
        
        
    }
    
}
