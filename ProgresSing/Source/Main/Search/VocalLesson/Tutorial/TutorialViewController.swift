//
//  TutorialViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/22.
//

import UIKit
import AVFoundation

public enum Tutorial: String {
    case belt = "belt"
    case vibrato = "vibrato"
    case vocalFry = "vocalFry"
}

class TutorialViewController: UIViewController, AVAudioPlayerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    var count = 0

    @IBOutlet weak var pitchButton: UIButton!
    @IBOutlet weak var pitchCountLabel: UILabel!
    @IBOutlet weak var beltButton: UIButton!
    @IBOutlet weak var beltCountLabel: UILabel!
    @IBOutlet weak var vibratoButton: UIButton!
    @IBOutlet weak var vibratoCountLabel: UILabel!
    @IBOutlet weak var vocalFryButton: UIButton!
    @IBOutlet weak var vocalFryCountLabel: UILabel!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var lyricLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var beltExample: UIButton!
    @IBOutlet weak var beltExampleLabel: UILabel!
    @IBOutlet weak var vocalFryExample: UIButton!
    @IBOutlet weak var vocalFryExampleLabel: UILabel!
    @IBOutlet weak var vibratoExample: UIButton!
    @IBOutlet weak var vibratoExampleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.pitchButton.setCornerRadius2(10)
        self.beltButton.setCornerRadius2(10)
        self.vibratoButton.setCornerRadius2(10)
        self.vocalFryButton.setCornerRadius2(10)
        self.skipButton.setCornerRadius(10)
        self.nextButton.setCornerRadius(10)
        //self.nextButton.isHidden = true

        self.beltExample.setCornerRadius2(10)
        self.vibratoExample.setCornerRadius2(10)
        self.vocalFryExample.setCornerRadius2(10)
        
        self.selectAudioFile()
        self.initPlay()
    }
    func selectAudioFile() {
        audioFile = Bundle.main.url(forResource: "fine_tutorial", withExtension: "wav")
    }
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        
    }
    func setTechnique(belt:Bool, vibrato:Bool, vocalFry:Bool) {
        self.beltButton.isEnabled = belt
        self.vibratoButton.isEnabled = vibrato
        self.vocalFryButton.isEnabled = vocalFry
    }

    @IBAction func skipButtonTouchUpInside(_ sender: Any) {
        //let vocalLessonVC = self.storyboard?.instantiateViewController(withIdentifier: "VocalLessonViewController") as! VocalLessonViewController
        let vocalLessonVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
        self.navigationController?.pushViewController(vocalLessonVC, animated: true)
        
    }
    @IBAction func nextButtonTouchUpInside(_ sender: Any) {
        self.count += 1
        switch count {
        case 1:
            setTechnique(belt: false, vibrato: true, vocalFry: false)
            beltButton.backgroundColor = .beltEnableFalse
            beltButton.setTitleColor(.labelFalse, for: .normal)
            beltExample.isHidden = true
            beltExampleLabel.isHidden = true
            
            vibratoButton.backgroundColor = .vibrato
            vibratoButton.setTitleColor(.white, for: .normal)
            vibratoExample.isHidden = false
            vibratoExampleLabel.isHidden = false
            playButton.setImage(UIImage(named: "vibratoPlay"), for: .normal)
            recordButton.setImage(UIImage(named: "vibratoRecord"), for: .normal)
            
        case 2:
            setTechnique(belt: false, vibrato: false, vocalFry: true)
           
            vibratoButton.backgroundColor = .vibratoEnableFalse
            vibratoButton.setTitleColor(.labelFalse, for: .normal)
            vibratoExample.isHidden = true
            vibratoExampleLabel.isHidden = true
            
            vocalFryButton.backgroundColor = .vocalFry
            vocalFryButton.setTitleColor(.white, for: .normal)
            vocalFryExample.isHidden = false
            vocalFryExampleLabel.isHidden = false
            playButton.setImage(UIImage(named: "vocalFryPlay"), for: .normal)
            recordButton.setImage(UIImage(named: "vocalFryRecord"), for: .normal)
        case 3:
            setTechnique(belt: false, vibrato: false, vocalFry: false)
            let vocalLessonVC = self.storyboard?.instantiateViewController(withIdentifier: "VocalLessonViewController") as! VocalLessonViewController
            self.navigationController?.pushViewController(vocalLessonVC, animated: true)
        default: break
        }
    }
    
    @IBAction func playButtonTouchUpInside(_ sender: Any) {
        print("play")
        audioPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("play done")
    }
    
    @IBAction func recordButtonTouchUpInside(_ sender: Any) {
    }
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        let mainTabBarController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        appDelegate.shouldSupportAllOrientation = true
        changeRootViewController(mainTabBarController)
    }
    
}
