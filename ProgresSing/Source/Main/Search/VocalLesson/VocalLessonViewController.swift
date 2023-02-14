//
//  VocalLessonViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/13.
//

import UIKit
import AVFoundation

class VocalLessonViewController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    let MAX_VOLUME : Float = 5.0
    var progressTimer : Timer!
    let timePlayerSelector:Selector = #selector(VocalLessonViewController.updatePlayTime)
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var koreanLirics1: UILabel!
    @IBOutlet weak var koreanLirics2: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.backgroundImageView.image = UIImage(named: "lessonBackground")
        self.backgroundImageView.transform = self.backgroundImageView.transform.rotated(by: .pi/2 * 3)
        self.selectAudioFile()
        self.initPlay()
        self.playAudio()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        appDelegate.shouldSupportAllOrientation = true
    }
  
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension VocalLessonViewController: AVAudioPlayerDelegate {
    func selectAudioFile() {
        audioFile = Bundle.main.url(forResource: "Fine", withExtension: "mp3")
    }
    @objc func updatePlayTime() {
        //lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        //pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
        var currentTime = convertNSTimeInterval2String(audioPlayer.currentTime)
        startTimeCheck(.time1, currentTime: currentTime)
        endTimeCheck(.time1, currentTime: currentTime)
    }
    func startTimeCheck(_ lyricsTime: StartLyricsTime, currentTime : String) {
        if (lyricsTime.rawValue == currentTime) {
            self.koreanLirics1.textColor = .blue
        }
    }
    func endTimeCheck(_ lyricsTime: EndLyricsTime, currentTime : String) {
        if (lyricsTime.rawValue == currentTime) {
            self.koreanLirics1.textColor = .white
        }
    }
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        //slVolume.maximumValue = MAX_VOLUME
        //slVolume.value = 1.0
        //pvProgressPlay.progress = 0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        
        //lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        //lblCurrentTime.text = convertNSTimeInterval2String(0)
    }
    func playAudio() {
        audioPlayer.play()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
}
