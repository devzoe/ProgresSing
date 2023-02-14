//
//  VocalLessonViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/13.
//

import UIKit
import AVFoundation
import CoreML
import Vision
import AVKit
import SoundAnalysis


class VocalLessonViewController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let audioController : AudioController = AudioController()
    
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    let MAX_VOLUME : Float = 5.0
    var playTimer : Timer!
    let timePlayerSelector:Selector = #selector(VocalLessonViewController.updatePlayTime)

    var audioRecorder : AVAudioRecorder!
    var recordFile :URL!
    var recordTimer : Timer!
    let timeRecordSelector:Selector = #selector(VocalLessonViewController.updateRecordTime)
    
    
    // MARK: audio engine property
    private let audioEngine = AVAudioEngine()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    //var resultsObserver = ResultsObserver()
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    
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
        
        //resultsObserver.delegate = self
        //inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        //analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        self.selectAudioFile()
        self.initPlay()
        self.playAudio()
        
        self.recordAudioFile()
        self.initRecord()
        self.startRecord()
        
        //self.startAudioEngine()
        self.audioController.startCapturingAudio()
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        appDelegate.shouldSupportAllOrientation = true
    }
  
    // MARK: back button
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: audio play

extension VocalLessonViewController: AVAudioPlayerDelegate {
    func selectAudioFile() {
        audioFile = Bundle.main.url(forResource: "Fine", withExtension: "mp3")
    }
    @objc func updatePlayTime() {
        let currentTime = convertNSTimeInterval2String(audioPlayer.currentTime)
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
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        
    }
    func playAudio() {
        audioPlayer.play()
        playTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
}


// MARK: Record

extension VocalLessonViewController: AVAudioRecorderDelegate {
    func recordAudioFile() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordFile = documentDirectory.appendingPathComponent("recordFile.m4a")
    }
    
    func initRecord() {
        let recordSettings = [
        AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
        AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey : 2,
        AVSampleRateKey : 44100.0] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: recordFile, settings: recordSettings)
        } catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        audioRecorder.delegate = self
        
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(" Error-setCategory : \(error)")
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(" Error-setActive : \(error)")
        }
    }
    func startRecord() {
        audioRecorder.record()
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
    }
    
    @objc func updateRecordTime() {
        let currentTime = convertNSTimeInterval2String(audioRecorder.currentTime)
        print("record time : \(currentTime)")
    }
}

/*
// MARK: Audio Engine
@available(iOS 15.0, *)
extension VocalLessonViewController {
    private func startAudioEngine() {
        
        do {
            // request
            if #available(iOS 15.0, *) {
                let request = try SNClassifySoundRequest(mlModel: new_model(model: MLModel()).model)
                try analyzer.add(request, withObserver: resultsObserver)
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
        }
        
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 8000, format: inputFormat) { buffer, time in
            self.analysisQueue.async {
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
        // audio engine start
        do{
            try audioEngine.start()
        }catch( _){
            print("error in starting the Audio Engine")
        }
    }
}

protocol AudioClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double)
}

// MARK: Prediction
extension VocalLessonViewController : AudioClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double) {
        DispatchQueue.main.async {
            // 결과값에 따라 화면에 반영
            
        }
    }
}

// MARK: ResultsObserver
class ResultsObserver: NSObject, SNResultsObserving {
    var delegate: AudioClassifierDelegate?
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }
        
        let confidence = classification.confidence * 100.0
        
        if confidence > 60 {
            delegate?.displayPredictionResult(identifier: classification.identifier, confidence: confidence)
        }
    }
}
*/
