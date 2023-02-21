//
//  FeedbackViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/16.
//

import UIKit

class FeedbackViewController: BaseViewController {
    var pitchCount = 0
    var vocalFryCount = 0
    var beltCount = 0
    var vibratoCount = 0
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.homeButton.setCornerRadius2(10)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func homeButtonTouchUpInside(_ sender: Any) {
        let mainTabBarController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        changeRootViewController(mainTabBarController)
    }
    
}
