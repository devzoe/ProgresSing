//
//  PlayRecordingViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/22.
//

import UIKit
import AVFoundation

class PlayRecordingViewController: UIViewController, AVAudioPlayerDelegate {
    var myRecord : MyRecord = MyRecord(imageName: "", artist: "", title: "", recordURL: nil)
    var isPlay = false
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectAudioFile()
        self.initPlay()
    }
    
    @IBAction func playButtonTouchUpInside(_ sender: Any) {
        if (isPlay) {
            self.playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            self.stopPlay()
        } else {
            self.playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            self.startPlay()
        }
    }
    func selectAudioFile() {
        audioFile = self.myRecord.recordURL
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
    
    func startPlay() {
        self.isPlay = true
        audioPlayer.play()
    }
    func stopPlay() {
        self.isPlay = false
        audioPlayer.stop()
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
    }
}
