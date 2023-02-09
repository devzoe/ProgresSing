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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popularityButton.setCornerRadius(25)
        self.balladButton.setCornerRadius(25)
        self.danceButton.setCornerRadius(25)
        self.hiphopButton.setCornerRadius(25)
        self.popsongButton.setCornerRadius(25)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
