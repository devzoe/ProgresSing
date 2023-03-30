//
//  BaseViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/10.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            
            self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
            self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
            self.navigationController?.navigationBar.backgroundColor = .black
            
            self.tabBarController?.tabBar.backgroundColor = .black
            self.tabBarController?.tabBar.shadowImage = UIImage()
            self.tabBarController?.tabBar.standardAppearance.backgroundColor = .black
            self.tabBarController?.tabBar.standardAppearance.shadowColor = .clear
        }
    }
}

