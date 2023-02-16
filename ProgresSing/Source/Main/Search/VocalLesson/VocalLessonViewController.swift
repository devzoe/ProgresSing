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
import SnapKit


class VocalLessonViewController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let audioController : AudioController = AudioController()
    let lyrics : Lyrics = Lyrics()
    
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    let MAX_VOLUME : Float = 5.0
    var playTimer : Timer!
    let timePlayerSelector:Selector = #selector(VocalLessonViewController.updatePlayTime)
    let referenceFrequency: Double = 440 // Hz

    var audioRecorder : AVAudioRecorder!
    var recordFile :URL!
    var recordTimer : Timer!
    let timeRecordSelector:Selector = #selector(VocalLessonViewController.updateRecordTime)
    
    var progressTimer1 = Timer()
    var secondsPassed1 : Float = 0
    var totalTime1 : Float = 0
    var progressTimer2 = Timer()
    var secondsPassed2 : Float = 0
    var totalTime2 : Float = 0
    
    // MARK: audio engine property
    private let audioEngine = AVAudioEngine()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    //var resultsObserver = ResultsObserver()
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    let strokeTextAttributes = [
      NSAttributedString.Key.strokeColor : UIColor.white,
      NSAttributedString.Key.foregroundColor : UIColor.blue,
      NSAttributedString.Key.strokeWidth : -4.0,
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)]
      as [NSAttributedString.Key : Any]
    let defaultTextAttributes = [
      NSAttributedString.Key.strokeColor : UIColor.white,
      NSAttributedString.Key.foregroundColor : UIColor.white,
      NSAttributedString.Key.strokeWidth : -4.0,
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)]
      as [NSAttributedString.Key : Any]

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var koreanLirics1: UILabel!
    @IBOutlet weak var koreanLirics2: UILabel!
    
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    lazy var lyric1 = LyricLabel()
    var timer = Timer()
    var lyricSeconds : Float = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         }
    /*
    func setUI(){
        self.view.addSubview(lyric1)
        lyric1.snp.makeConstraints { make in
            make.leading.equalTo(progress1)
            make.top.equalToSuperview()
        }
        lyric1.textColor = .white
        lyric1.font = .systemFont(ofSize: 50)
        lyric1.color = .blue
    }
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUI()
        self.navigationController?.navigationBar.isHidden = true
        self.backgroundImageView.image = UIImage(named: "lessonBackground")
        self.backgroundImageView.transform = self.backgroundImageView.transform.rotated(by: .pi/2 * 3)
        self.koreanLirics1.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[0], attributes: defaultTextAttributes)
        self.koreanLirics2.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[1], attributes: defaultTextAttributes)
        
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
        //xself.audioController.startCapturingAudio()
        
       
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
        audioFile = Bundle.main.url(forResource: "Fine-Melody", withExtension: "mp3")
    }
    @objc func updatePlayTime() {
        print("play time : \(audioPlayer.currentTime)")
        let currentTime = convertNSTimeInterval2String(audioPlayer.currentTime)
        for i in 0..<lyrics.startLyricsTime1.count {
            
            self.startTimeCheck1(i, lyrics.startLyricsTime1[i], currentTime: currentTime)
            self.endTimeCheck1(lyrics.endLyricsTime1[i], currentTime: currentTime)
            self.startTimeCheck2(i, lyrics.startLyricsTime2[i], currentTime: currentTime)
            self.endTimeCheck2(lyrics.endLyricsTime2[i], currentTime: currentTime)
            
        }
        
    }
    func startTimeCheck1(_ index: Int, _ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics1.textColor = .blue
            
            //self.koreanLirics1.text = lyrics.koreanLyrics[index*2]
            //self.koreanLirics2.text = lyrics.koreanLyrics[index*2+1]
            self.koreanLirics1.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2], attributes: strokeTextAttributes)
            self.koreanLirics2.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+1], attributes: defaultTextAttributes)
                                               
            DispatchQueue.main.async { [self] in
                self.progressTimer1.invalidate()
                self.progress1.progress = 0.0
                self.secondsPassed1 = 0
                self.progressTimer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                self.totalTime1 = self.convertString2Time(self.lyrics.endLyricsTime1[index]) - self.convertString2Time(lyricsTime)
                /*
                self.lyric1.text = self.lyrics.koreanLyrics[index*2]
                let timer = Timer.scheduledTimer(timeInterval: 1.0/Double(totalTime1), target: self, selector: #selector(update), userInfo: nil, repeats: true)
                 */
            }
            
        
        }
    }
    /*
    @objc func update(){
        lyric1.progress += 1
       
    }
     */

    @objc func updateTimer() {
        if secondsPassed1 < totalTime1 {
            secondsPassed1 += 0.1
            progress1.progress = Float(secondsPassed1) / Float(totalTime1)
        } else {
            progressTimer1.invalidate()
        }
        
    }
    func endTimeCheck1(_ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics1.textColor = .white
        }
    }
    func startTimeCheck2(_ index : Int,_ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics2.textColor = .blue
            self.koreanLirics1.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+2], attributes: defaultTextAttributes)
            self.koreanLirics2.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+1], attributes: strokeTextAttributes)
        }
    }
    func endTimeCheck2(_ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics2.textColor = .white
        }
    }
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    func convertString2Time(_ time:String) -> Float {
        let components = time.split { $0 == ":" } .map { (x) -> Float in return Float(String(x))! }

        let hours = components[0]
        let minutes = components[1]
        let result = hours * 60 + minutes
        print("real time : \(result)")
        return result
    }
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        progress1.progress = 0
        progress2.progress = 0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        
    }
    func playAudio() {
        audioPlayer.play()
        playTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    func getSongPitch() -> Double {
        let power = audioPlayer?.averagePower(forChannel: 0) ?? -160.0 // default value if audio player is nil
        let pitch = pow(10, (0.05 * Double(power))) * referenceFrequency
        return pitch
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
