//
//  TapBarController.swift
//  Codler
//
//  Created by Евгений Парфененков on 10.08.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    private let mainViewController = DI.shared.getMainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    private func setUp() {
        tabBar.tintColor = .white
        tabBar.backgroundColor = UIColor(hex: "#141415FF") ?? .brown
        
        loadViewControllers()
    }
    
    private func loadViewControllers() {
        viewControllers = [
            
            customVC(VC: mainViewController, title: "Главная", image: UIImage(systemName: "house.fill") ?? .remove),        ]
    }
    
    private func customVC(VC: UIViewController, title: String, image: UIImage) -> UIViewController {
        VC.tabBarItem.title = title
        VC.tabBarItem.image = image
        return VC
    }
}
