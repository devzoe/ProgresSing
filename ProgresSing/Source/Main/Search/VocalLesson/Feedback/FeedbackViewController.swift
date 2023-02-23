//
//  FeedbackViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/16.
//

import UIKit

class FeedbackViewController: BaseViewController {
    let lyric : Lyrics = Lyrics()
    
    var pitchCount = 0
    var vocalFryCount = 0
    var beltCount = 0
    var vibratoCount = 0
    
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var pitchScoreLabel: UILabel!
    @IBOutlet weak var beltScoreLabel: UILabel!
    @IBOutlet weak var vibratoScoreLabel: UILabel!
    @IBOutlet weak var vocalFryScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.homeButton.setCornerRadius2(10)
        self.calculateScore()
    }
    
    func calculateScore() {
        let pitchTotalCount = 469
        let beltTotalCount = self.lyric.beltTime.count
        let vibratoTotalCount = self.lyric.vibratoTime.count
        let vocalFryTotalCount = self.lyric.vocalFryTime.count
        

        let pitchScore = Float(pitchTotalCount+pitchCount)/Float(pitchTotalCount) * 100
        let beltScore = Float(beltCount)/Float(beltTotalCount) * 100
        let vibratoScore = Float(vibratoCount)/Float(vibratoTotalCount) * 100
        let vocalFryScore = Float(vocalFryCount)/Float(vocalFryTotalCount) * 100
        
        self.pitchScoreLabel.text = String(format: "%.2f", pitchScore)
        self.beltScoreLabel.text = String(format: "%.2f",beltScore)
        self.vibratoScoreLabel.text = String(format: "%.2f",vibratoScore)
        self.vocalFryScoreLabel.text = String(format: "%.2f",vocalFryScore)
        
        let finalScore = (pitchScore+beltScore+vibratoScore+vocalFryScore) / 4
        self.finalScoreLabel.text = String(format: "%.2f",finalScore)
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
