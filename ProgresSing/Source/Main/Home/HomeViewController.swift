//
//  HomeViewController.swift
//  Javis
//
//  Created by 남경민 on 2023/02/09.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var popularityButton: UIButton!
    @IBOutlet weak var balladButton: UIButton!
    @IBOutlet weak var danceButton: UIButton!
    
    @IBOutlet weak var hiphopButton: UIButton!
    @IBOutlet weak var popsongButton: UIButton!
    
    @IBOutlet weak var firstScrollView: UIScrollView!
    @IBOutlet weak var popularityButtonLeading: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popularityButton.setCornerRadius(25)
        self.balladButton.setCornerRadius(25)
        self.danceButton.setCornerRadius(25)
        self.hiphopButton.setCornerRadius(25)
        self.popsongButton.setCornerRadius(25)
    }
}
