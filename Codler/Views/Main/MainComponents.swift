//
//  Components.swift
//  Codler
//
//  Created by Евгений Парфененков on 13.07.2023.
//

import Foundation
import UIKit
import SwiftUI

protocol ComponentsProtocol {
    
    func buttonAppleSignIn() -> UIButton
    
}

public class MainComponents: ComponentsProtocol {
    
    /// Login Screen ==================================================================================================================================================================
    
    func buttonAppleSignIn() -> UIButton {
        let button = UIButton()
        let image = UIImage(named: "TemplateSignInWithApple")

        button.layer.cornerRadius = 20
        button.setImage(image, for: .normal)

        return button
    }
    
    final class SmallProfile: UIView {
        
        private var name = String()
        private var photo = UIImage()
        private var status = Int()
        
        func setName(name: String) { self.nickName.text = name }
        func setImage(image: UIImage) { self.imageView.image = image }
        func updateRating(rating: Int) {
            
            if 0 <= rating && rating < 300 {
                levelTextView.text = "Уровень: Стажер"
                levelTextView.textColor = UIColor(hex: "#707F99FF")
                
                let newProgress = Int(round(Float(rating) / 300 * 100))
                progressPercentageView.text = String(newProgress) + "%"
                changeCodeFather(isLead: false)
                
                progressView.layer.borderColor = UIColor(hex: "#707F99FF")?.cgColor
                progressView.progressTintColor = UIColor(hex: "#707F99FF")
                if Float(rating) / 300 >= 0.01 { progressView.progress = Float(rating) / 300 }
                else { progressView.progress = 0 }
                
            } else if 300 <= rating && rating < 1000 {
                levelTextView.text = "Уровень: Junior"
                levelTextView.textColor = UIColor(hex: "#3AEA1FFF")
                
                let newProgress = Int(round(Float(rating) / 1000 * 100))
                progressPercentageView.text = String(newProgress) + "%"
                changeCodeFather(isLead: false)
                
                progressView.layer.borderColor = UIColor(hex: "#3AEA1FFF")?.cgColor
                progressView.progressTintColor = UIColor(hex: "#3AEA1FFF")
                if Float(rating) / 1000 >= 0.01 { progressView.progress = Float(rating) / 1000 }
                else { progressView.progress = 0 }
                
            } else if 1000 <= rating && rating < 2000 {
                levelTextView.text = "Уровень: Middle"
                levelTextView.textColor = UIColor(hex: "#FFD600FF")
                
                let newProgress = Int(round(Float(rating) / 2000 * 100))
                progressPercentageView.text = String(newProgress) + "%"
                changeCodeFather(isLead: false)
                
                progressView.layer.borderColor = UIColor(hex: "#FFD600FF")?.cgColor
                progressView.progressTintColor = UIColor(hex: "#FFD600FF")
                if Float(rating) / 2000 >= 0.01 { progressView.progress = Float(rating) / 2000 }
                else { progressView.progress = 0 }
                
            } else if 2000 <= rating && rating < 3500 {
                levelTextView.text = "Уровень: Senior"
                levelTextView.textColor = UIColor(hex: "#FF3D00FF")
                
                let newProgress = Int(round(Float(rating) / 3500 * 100))
                progressPercentageView.text = String(newProgress) + "%"
                changeCodeFather(isLead: false)
                
                progressView.layer.borderColor = UIColor(hex: "#FF3D00FF")?.cgColor
                progressView.progressTintColor = UIColor(hex: "#FF3D00FF")
                if Float(rating) / 3500 >= 0.01 { progressView.progress = Float(rating) / 3500 }
                else { progressView.progress = 0 }
                
            } else if 3500 <= rating {
                levelTextView.text = "Уровень: Lead"
                levelTextView.textColor = UIColor(hex: "#8E48EAFF")
                
                let newProgress = Int(round(Float(rating) / 300 * 100))
                progressPercentageView.text = String(newProgress) + "%"
                changeCodeFather(isLead: true)
                
                progressView.layer.borderColor = UIColor(hex: "#8E48EAFF")?.cgColor
                progressView.progressTintColor = UIColor(hex: "#8E48EAFF")
                progressView.progress = Float(rating) / 10000
            }
            
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        
            setUp()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private let nickName = UILabel()
        private let levelTextView = UILabel()
        private let imageView = UIImageView()
        private let progressView = UIProgressView()
        private let progressTextView = UILabel()
        private let progressPercentageView = UILabel()
        private let buttonImage = UIImageView()
        private let codeFather = UIImageView()
        
        private func setUp() {
            self.backgroundColor = UIColor(hex: "#151417FF")
            self.layer.cornerRadius = 40
            
            addPhoto()
            addNickName()
            addLevel()
            addProgressView()
            addprogressText()
            addprogressPercentage()
            addButtonImage()
            addCodeFather()
        }
        
        private func addPhoto() {
        
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            let imageViewConstraints = [
                imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17),
                imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17),
            ]
            
            self.addSubview(imageView)
            NSLayoutConstraint.activate(imageViewConstraints)
        }
        
        private func addNickName() {
            nickName.adjustsFontSizeToFitWidth = true
            nickName.font = .bold(size: 100)
            
            nickName.translatesAutoresizingMaskIntoConstraints = false
            
            let nickNameConstraints = [
                nickName.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 0),
                nickName.bottomAnchor.constraint(equalTo: self.imageView.centerYAnchor, constant: 5),
                nickName.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 20),
                nickName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            ]
            
            self.addSubview(nickName)
            NSLayoutConstraint.activate(nickNameConstraints)
        }
        
        private func addLevel() {
            levelTextView.adjustsFontSizeToFitWidth = true
            levelTextView.font = .medium(size: 100)
            
            levelTextView.translatesAutoresizingMaskIntoConstraints = false
            
            let levelTextViewConstraints = [
                levelTextView.topAnchor.constraint(equalTo: self.imageView.centerYAnchor, constant: -5),
                levelTextView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 0),
                levelTextView.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 20),
                levelTextView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.34),
            ]
            
            self.addSubview(levelTextView)
            NSLayoutConstraint.activate(levelTextViewConstraints)
        }
        
        private func addProgressView() {
            progressView.trackTintColor = .clear
            
            progressView.layer.cornerRadius = 17
            progressView.clipsToBounds = true
            progressView.layer.borderWidth = 1
            
            progressView.subviews[1].layer.cornerRadius = 17
            progressView.subviews[1].clipsToBounds = true
            
            progressView.translatesAutoresizingMaskIntoConstraints = false
            
            let progressViewConstraints = [
                progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                progressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                progressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
                progressView.heightAnchor.constraint(equalToConstant: 35)
            ]
            
            self.addSubview(progressView)
            NSLayoutConstraint.activate(progressViewConstraints)
        }
        
        private func addprogressText() {
            progressTextView.adjustsFontSizeToFitWidth = true
            progressTextView.font = .medium(size: 60)
            progressTextView.text = "Прогресс"
            
            progressTextView.translatesAutoresizingMaskIntoConstraints = false
            
            let progressTextViewConstraints = [
                progressTextView.bottomAnchor.constraint(equalTo: self.progressView.topAnchor, constant: 10),
                progressTextView.leftAnchor.constraint(equalTo: self.progressView.leftAnchor, constant: 5),
                progressTextView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            ]
            
            self.addSubview(progressTextView)
            NSLayoutConstraint.activate(progressTextViewConstraints)
        }
        
        private func addprogressPercentage() {
            progressPercentageView.adjustsFontSizeToFitWidth = true
            progressPercentageView.font = .systemFont(ofSize: 80, weight: .medium)
            progressPercentageView.textAlignment = .right
            
            progressPercentageView.translatesAutoresizingMaskIntoConstraints = false
            
            let progressPercentageViewConstraints = [
                progressPercentageView.bottomAnchor.constraint(equalTo: self.progressView.topAnchor, constant: -5),
                progressPercentageView.rightAnchor.constraint(equalTo: self.progressView.rightAnchor, constant: -5),
                progressPercentageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
                progressPercentageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17),
            ]
            
            self.addSubview(progressPercentageView)
            NSLayoutConstraint.activate(progressPercentageViewConstraints)
        }
        
        private func addButtonImage() {
            buttonImage.image = UIImage(named: "ImageActionButton")
//            buttonImage.image = .add
            
            buttonImage.translatesAutoresizingMaskIntoConstraints = false
            
            let buttonImageConstraints = [
                buttonImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
                buttonImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25),
                buttonImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08),
                buttonImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08),
            ]
            
            self.addSubview(buttonImage)
            NSLayoutConstraint.activate(buttonImageConstraints)
        }
        
        private func addCodeFather() {
            codeFather.image = UIImage(named: "TemplateCodeFather")
//            buttonImage.image = .add
            
            codeFather.translatesAutoresizingMaskIntoConstraints = false
            
            let codeFatherConstraints = [
                codeFather.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                codeFather.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                codeFather.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
                codeFather.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.21),
            ]
            
            self.addSubview(codeFather)
            NSLayoutConstraint.activate(codeFatherConstraints)
        }
        
        private func changeCodeFather(isLead: Bool) {
            if isLead {
                self.codeFather.isHidden = false
                self.progressView.isHidden = true
                self.progressTextView.isHidden = true
                self.progressPercentageView.isHidden = true
            } else {
                self.codeFather.isHidden = true
                self.progressView.isHidden = false
                self.progressTextView.isHidden = false
                self.progressPercentageView.isHidden = false
            }
            
            
        }
        
    }
    
    final class FastGameButton: UIView {
        
        override init(frame: CGRect) { 
            super.init(frame: frame)
            setUp()
        }
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        let textView = UILabel()
        let time = UIImageView()
        let persons = UIImageView()
        let imageView = UIImageView()
        
        private func setUp() {
            self.backgroundColor = UIColor(hex: "#151417FF")
            self.layer.cornerRadius = 40
            self.clipsToBounds = true
            setUpTextView()
            setUpTime()
            setUpPersons()
            setUpImageView()
        }
        
        private func setUpTextView() {
            textView.adjustsFontSizeToFitWidth = true
            textView.font = .bold(size: 60)
            textView.text = "Быстрый бой"
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            let textViewConstraints = [
                textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                textView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            ]
            
            self.addSubview(textView)
            NSLayoutConstraint.activate(textViewConstraints)
        }
        
        private func setUpTime() {
            time.image = UIImage(named: "TemplateTime")
            
            time.translatesAutoresizingMaskIntoConstraints = false
            
            let timeConstraints = [
                time.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: -10),
                time.leftAnchor.constraint(equalTo: self.textView.leftAnchor, constant: 0),
                time.widthAnchor.constraint(equalTo: self.textView.widthAnchor, multiplier: 0.4),
            ]
            
            self.addSubview(time)
            NSLayoutConstraint.activate(timeConstraints)
        }
        
        private func setUpPersons() {
            persons.image = UIImage(named: "TemplatePersons")
            
            persons.translatesAutoresizingMaskIntoConstraints = false
            
            let personsConstraints = [
                persons.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: -10),
                persons.leftAnchor.constraint(equalTo: time.rightAnchor, constant: 20),
                persons.widthAnchor.constraint(equalTo: self.textView.widthAnchor, multiplier: 0.35),
            ]
            
            self.addSubview(persons)
            NSLayoutConstraint.activate(personsConstraints)
        }
        
        private func setUpImageView() {
            imageView.image = UIImage(named: "ImageCode")
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            let personsConstraints = [
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 45),
                imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
                imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            ]
            
            self.addSubview(imageView)
            NSLayoutConstraint.activate(personsConstraints)
        }
    }
    
    final class TrainingButton: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        let textView = UILabel()
        let imageView = UIImageView()
        
        private func setUp() {
            self.backgroundColor = UIColor(hex: "#151417FF")
            self.layer.cornerRadius = 40
            self.clipsToBounds = true
            
            setUpTextView()
            setUpImage()
        }
        
        private func setUpTextView() {
            textView.adjustsFontSizeToFitWidth = true
            textView.font = .bold(size: 60)
            textView.text = "Тренинг"
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            let textViewConstraints = [
                textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                textView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            ]
            
            self.addSubview(textView)
            NSLayoutConstraint.activate(textViewConstraints)
        }
        
        private func setUpImage() {
            imageView.image = UIImage(named: "ImageTraining")
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            let personsConstraints = [
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
                imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            ]
            
            self.addSubview(imageView)
            NSLayoutConstraint.activate(personsConstraints)
        }
    }
    
    final class GameModesButton: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        let textView = UILabel()
        let imageView = UIImageView()
        
        private func setUp() {
            self.backgroundColor = UIColor(hex: "#151417FF")
            self.layer.cornerRadius = 40
            self.clipsToBounds = true
            
            setUpTextView()
            setUpImage()
        }
        
        private func setUpTextView() {
            textView.adjustsFontSizeToFitWidth = true
            textView.font = .bold(size: 60)
            textView.text = "Режимы"
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            let textViewConstraints = [
                textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                textView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            ]
            
            self.addSubview(textView)
            NSLayoutConstraint.activate(textViewConstraints)
        }
        
        private func setUpImage() {
            imageView.image = UIImage(named: "ImageGameModes")
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            let personsConstraints = [
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
                imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            ]
            
            self.addSubview(imageView)
            NSLayoutConstraint.activate(personsConstraints)
        }
    }
    
}
