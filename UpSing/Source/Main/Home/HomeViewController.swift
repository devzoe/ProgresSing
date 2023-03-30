//
//  HomeViewController.swift
//  Javis
//
//  Created by 남경민 on 2023/02/09.
//

import UIKit
import AVFAudio

class HomeViewController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var popularityButton: UIButton!
    @IBOutlet weak var balladButton: UIButton!
    @IBOutlet weak var danceButton: UIButton!
    @IBOutlet weak var hiphopButton: UIButton!
    @IBOutlet weak var popsongButton: UIButton!
    
    @IBOutlet weak var playButton1: UIButton!
    @IBOutlet weak var playButton2: UIButton!
    @IBOutlet weak var playButton3: UIButton!
    @IBOutlet weak var playButton4: UIButton!
    @IBOutlet weak var playButton5: UIButton!
    @IBOutlet weak var playButton6: UIButton!
    @IBOutlet weak var playButton7: UIButton!
    @IBOutlet weak var playButton8: UIButton!
    @IBOutlet weak var playButton9: UIButton!
    @IBOutlet weak var playButton10: UIButton!
    @IBOutlet weak var playButton11: UIButton!
    @IBOutlet weak var playButton12: UIButton!
    @IBOutlet weak var playButton13: UIButton!
    @IBOutlet weak var playButton14: UIButton!
    @IBOutlet weak var playButton15: UIButton!
    @IBOutlet weak var playButton16: UIButton!
    
    @IBOutlet weak var lessonLabel: UILabel!
    
    @IBOutlet weak var practiceView: UIView!
    @IBOutlet weak var practicePlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Dismiss Keyboard When Tapped Arround
        self.dismissKeyboardWhenTappedAround()
        // Initialize Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        // Add Tap Gesture Recognizer
        self.lessonLabel.addGestureRecognizer(tapGestureRecognizer)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        var practice = UITapGestureRecognizer(target: self, action: #selector(self.practice(gesture:)))
        self.practiceView.addGestureRecognizer(practice)
        self.requestMicrophonePermission()
    }
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        print("push")
        let lessonVideoVC = self.storyboard?.instantiateViewController(withIdentifier: "LessonVideoViewController") as! LessonVideoViewController
        self.navigationController?.pushViewController(lessonVideoVC, animated: true)
    }
    
    func setUpUI() {
        self.popularityButton.setCornerRadius(25)
        self.balladButton.setCornerRadius(25)
        self.danceButton.setCornerRadius(25)
        self.hiphopButton.setCornerRadius(25)
        self.popsongButton.setCornerRadius(25)
        self.playButton1.setCornerRadius(5)
        self.playButton2.setCornerRadius(5)
        self.playButton3.setCornerRadius(5)
        self.playButton4.setCornerRadius(5)
        self.playButton5.setCornerRadius(5)
        self.playButton6.setCornerRadius(5)
        self.playButton7.setCornerRadius(5)
        self.playButton8.setCornerRadius(5)
        self.playButton9.setCornerRadius(5)
        self.playButton10.setCornerRadius(5)
        self.playButton11.setCornerRadius(5)
        self.playButton12.setCornerRadius(5)
        self.playButton13.setCornerRadius(5)
        self.playButton14.setCornerRadius(5)
        self.playButton15.setCornerRadius(5)
        self.playButton16.setCornerRadius(5)
        self.practicePlayButton.setCornerRadius(5)
        
        practiceView.layer.borderColor = UIColor.black.cgColor
        practiceView.layer.borderWidth = 2
    }
    
    func requestMicrophonePermission(){
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                print("Mic: 권한 허용")
            } else {
                print("Mic: 권한 거부")
            }
        })
    }
    
    @objc func practice(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "SearchStoryboard", bundle: Bundle.main)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        self.tabBarController?.tabBar.isHidden = true
        appDelegate.shouldSupportAllOrientation = false
        self.navigationController?.pushViewController(tutorialVC, animated: true)
        
    }
}

