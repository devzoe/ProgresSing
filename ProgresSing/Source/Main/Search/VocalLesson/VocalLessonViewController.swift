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
import Accelerate
import RosaKit


class VocalLessonViewController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let lyrics : Lyrics = Lyrics()
    
    var audioPlayer : AVAudioPlayer!
    //var audioFile : URL!
    let MAX_VOLUME : Float = 5.0
    //var playTimer : Timer!
    //let timePlayerSelector:Selector = #selector(VocalLessonViewController.updatePlayTime)
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
    //private let audioEngine = AVAudioEngine()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    //var resultsObserver = ResultsObserver()
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    let strokeTextAttributes = [
      NSAttributedString.Key.strokeColor : UIColor.progressingPuple,
      NSAttributedString.Key.foregroundColor : UIColor.white,
      NSAttributedString.Key.strokeWidth : -4.0,
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)]
      as [NSAttributedString.Key : Any]
    let defaultTextAttributes = [
      NSAttributedString.Key.strokeColor : UIColor.white,
      NSAttributedString.Key.foregroundColor : UIColor.white,
      NSAttributedString.Key.strokeWidth : -4.0,
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)]
      as [NSAttributedString.Key : Any]
    let pitchTextAttributes = [
      NSAttributedString.Key.strokeColor : UIColor.red,
      NSAttributedString.Key.foregroundColor : UIColor.white,
      NSAttributedString.Key.strokeWidth : -4.0,
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)]
      as [NSAttributedString.Key : Any]


    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var koreanLirics1: UILabel!
    @IBOutlet weak var koreanLirics2: UILabel!
    
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    
    @IBOutlet weak var pitchButton: UIButton!
    @IBOutlet weak var pitchCountLabel: UILabel!
    var pitchCount : Int = 0
    
    @IBOutlet weak var vocalFryButton: UIButton!
    @IBOutlet weak var vocalFryCountLabel: UILabel!
    @IBOutlet weak var BeltButton: UIButton!
    @IBOutlet weak var beltCountLabel: UILabel!
    
    @IBOutlet weak var vibratoButton: UIButton!
    @IBOutlet weak var vibratoCountLabel: UILabel!
    lazy var lyric1 = LyricLabel()
    var timer = Timer()
    var lyricSeconds : Float = 0
    var songPitch : Float = 0
    var voicePitch : Float = 0
    
    
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()

    var audioBuffer: AVAudioPCMBuffer?
    var playTimer = Timer()
    //let timePlayerSelector:Selector = #selector(VocalLessonViewController.updatePlayTime)
    
    let timePitchNode = AVAudioUnitTimePitch()
    // Attach audio input node for voice recording
    var audioInputNode : AVAudioInputNode!
    var audioInputFormat : AVAudioFormat!
    
    var audioFileURL : URL!
    var audioFile : AVAudioFile!
    var audioFormat :AVAudioFormat!
    var prevRMSValue : Float = 0.3
    
    //fft setup object for 1024 values going forward (time domain -> frequency domain)
    let fftSetup = vDSP_DFT_zop_CreateSetup(nil, 1024, vDSP_DFT_Direction.FORWARD)
    
    let model = try! vocal_training_model(configuration: MLModelConfiguration())
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            print("Check1 : \(Thread.current)")
            self.navigationController?.navigationBar.isHidden = true
            self.backgroundImageView.image = UIImage(named: "lessonBackground")
            self.backgroundImageView.transform = self.backgroundImageView.transform.rotated(by: .pi/2 * 3)
            self.koreanLirics1.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[0], attributes: self.defaultTextAttributes)
            self.koreanLirics2.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[1], attributes: self.defaultTextAttributes)
            self.pitchButton.setCornerRadius2(10)
            self.vocalFryButton.setCornerRadius2(10)
            self.BeltButton.setCornerRadius2(10)
            self.vibratoButton.setCornerRadius2(10)
        }
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
        
                
        //resultsObserver.delegate = self
        //inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        //analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        //self.selectAudioFile()
        //let audioPlayer = AudioPlayer(audioFile: try! AVAudioFile(forReading: audioFile))
        //audioPlayer.play()
        //self.initPlay()
        //self.playAudio()
        DispatchQueue.global().async {
            print("check2 : \(Thread.current)")
            self.initPlay()
        }
        
        
        //self.play()
        
        //self.recordAudioFile()
        //self.initRecord()
        //self.startRecord()
        
        //self.startAudioEngine()
        //let audioController : AudioController = AudioController()
        //audioController.startCapturingAudio()
        
       
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

extension VocalLessonViewController {
    func initPlay() {
        // Connect audio player and time pitch node to audio engine's output node
        audioFileURL = Bundle.main.url(forResource: "Fine-Melody", withExtension: "mp3")!
        audioFile = try! AVAudioFile(forReading: audioFileURL)
        audioFormat = audioFile.processingFormat
        audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
        try! audioFile.read(into: audioBuffer!)
        
        audioEngine.attach(audioPlayerNode)
        audioInputNode = audioEngine.inputNode
        //audioEngine.attach(audioInputNode)
        
        // Connect audio player and time pitch node to audio engine's output node
        // audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        audioEngine.connect(audioPlayerNode, to: audioEngine.outputNode, format: audioFormat)
        //audioEngine.connect(audioInputNode, to: audioEngine.mainMixerNode, format: audioInputNode.inputFormat(forBus: 0))
        
        // Start music playback
        audioPlayerNode.scheduleBuffer(audioBuffer!)
        
        let bus = 0
        let inputFormat = audioInputNode.inputFormat(forBus: bus)
        
        
        self.audioInputNode.installTap(onBus: bus, bufferSize: 1024, format: inputFormat) { [self] (buffer, time) in
            let voicePitch = self.processAudioData(buffer: buffer)
            
            print("voice Pitch : \(voicePitch)")
            print("record time : \(time)")
            self.processBuffer(buffer)
            
            DispatchQueue.main.async {
                self.voicePitch = voicePitch
            }
        }
        self.audioPlayerNode.installTap(onBus: bus, bufferSize: 1024, format: self.audioFormat) { (buffer, time) in
            let songPitch = self.processAudioData(buffer: buffer)
            print("song Pitch : \(songPitch)")
            print("play time : \(time)")
            DispatchQueue.main.async {
                self.songPitch = songPitch
            }
            
            DispatchQueue.global().async {
                if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime)
                {
                    var currentTime = Float(playerTime.sampleTime) / Float(playerTime.sampleRate)
                    let currentTimeString = self.convertNSTimeInterval2String(currentTime)
                    print("Current time: \(currentTime)")
                    
                    
                    for i in 0..<self.lyrics.startLyricsTime1.count {
                        
                        self.startTimeCheck1(i, self.lyrics.startLyricsTime1[i], currentTime: currentTimeString)
                        self.endTimeCheck1(self.lyrics.endLyricsTime1[i], currentTime: currentTimeString)
                        self.pitchCheck1(index: i, startTime1: self.lyrics.startLyricsTime1[i], endTime1: self.lyrics.endLyricsTime1[i], currentTime: currentTimeString)
                        if (i < self.lyrics.startLyricsTime2.count) {
                            self.startTimeCheck2(i, self.lyrics.startLyricsTime2[i], currentTime: currentTimeString)
                            self.endTimeCheck2(self.lyrics.endLyricsTime2[i], currentTime: currentTimeString)
                            
                            self.pitchCheck2(index: i, startTime2:  self.lyrics.startLyricsTime2[i], endTime2: self.lyrics.endLyricsTime2[i], currentTime: currentTimeString)
                        }
                        
                    }
                }
            }
            
        }
        
        //audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioBuffer!.format)
        try! audioEngine.start()
        audioPlayerNode.play()
        
        // Wait for music playback to finish
        while audioPlayerNode.isPlaying {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        }
    }
    func processBuffer(_ buffer: AVAudioPCMBuffer) {
        // Prepare the input data for the model
        let audioData = buffer.floatChannelData![0]
        //fft
        //let fftMagnitudes = SignalProcessing.fft(data: audioData, setup: fftSetup!)
        let audioDataPtr = UnsafeMutablePointer<Float>(mutating: audioData)
        let input = try! MLMultiArray(dataPointer: audioDataPtr, shape: [1,128,87,1], dataType: .float32, strides: [1,1,1,1])
        
        //for i in 0..<buffer.frameLength {
         //   input[i] = Float(buffer.floatChannelData!.pointee[Int(i)]) / 32768.0
        //}
        
        // Pass the input data to the model
        //let prediction = try! model.prediction(input: vocal_training_modelInput(conv2d_input: input))
        
        // Get the output result
        //let output = prediction.Identity
        
        // Update the UI with the output result
        DispatchQueue.main.async {
            // Update the UI with the output value
            //print("model output : \(output)")
            //print("fft magnitudes : \(fftMagnitudes)")
            print("input : \(input)")
        }
    }
        
    func processAudioData(buffer: AVAudioPCMBuffer) -> Float{
        guard let channelData = buffer.floatChannelData?[0] else {return 0}
        let frames = buffer.frameLength
        
        //rms
        let rmsValue = SignalProcessing.rms(data: channelData, frameLength: UInt(frames))
        //print("rmsValue : \(rmsValue)")
        //let interpolatedResults = SignalProcessing.interpolate(point1: prevRMSValue, point2: rmsValue, num: 7)
        //prevRMSValue = rmsValue
        
        //fft
        //let fftMagnitudes =  SignalProcessing.fft(data: channelData, setup: fftSetup!)
        //print("fftMagnotudes: \(fftMagnitudes)")
        return rmsValue
    }
    func stop() {
        audioPlayerNode.stop()
        playTimer.invalidate()
    }
    
    //토스트 메시지
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)){
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview()})
        
    }
    
    /*
    @objc func updatePlayTime() {
        if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime)
        {
            var currentTime = Float(playerTime.sampleTime) / Float(playerTime.sampleRate)
            let currentTimeString = convertNSTimeInterval2String(currentTime)
            print("Current time: \(currentTime)")
            
            for i in 0..<lyrics.startLyricsTime1.count {
                
                self.startTimeCheck1(i, lyrics.startLyricsTime1[i], currentTime: currentTimeString)
                self.endTimeCheck1(lyrics.endLyricsTime1[i], currentTime: currentTimeString)
                if (i < lyrics.startLyricsTime2.count) {
                    self.startTimeCheck2(i, lyrics.startLyricsTime2[i], currentTime: currentTimeString)
                    self.endTimeCheck2(lyrics.endLyricsTime2[i], currentTime: currentTimeString)
                }
                
            }
        }
    }
     */
}

extension VocalLessonViewController: AVAudioPlayerDelegate {
    /*
     func selectAudioFile() {
     audioFile = Bundle.main.url(forResource: "Fine-Melody", withExtension: "mp3")
     }
     */
    /*
     @objc func updatePlayTime() {
     print("play time : \(audioPlayer.currentTime)")
        let currentTime = convertNSTimeInterval2String(audioPlayer.currentTime)
        for i in 0..<lyrics.startLyricsTime1.count {
            
            self.startTimeCheck1(i, lyrics.startLyricsTime1[i], currentTime: currentTime)
            self.endTimeCheck1(lyrics.endLyricsTime1[i], currentTime: currentTime)
            if (i < lyrics.startLyricsTime2.count) {
                self.startTimeCheck2(i, lyrics.startLyricsTime2[i], currentTime: currentTime)
                self.endTimeCheck2(lyrics.endLyricsTime2[i], currentTime: currentTime)
            }
            
        }
        
    }
     */
    func startTimeCheck1(_ index: Int, _ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics1.textColor = .blue
            
            //self.koreanLirics1.text = lyrics.koreanLyrics[index*2]
            //self.koreanLirics2.text = lyrics.koreanLyrics[index*2+1]
                                                           
            DispatchQueue.main.async { [self] in
                self.koreanLirics1.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2], attributes: strokeTextAttributes)
                if (index < lyrics.startLyricsTime1.count - 1 ) {
                    self.koreanLirics2.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+1], attributes: defaultTextAttributes)
                }

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
    func pitchCheck1(index : Int, startTime1: String, endTime1: String, currentTime : String) {
        let startTime1 = self.convertString2Time(startTime1)
        let endTime1 = self.convertString2Time(endTime1)
        let currentTime = self.convertString2Time(currentTime)
        if (currentTime < endTime1 && currentTime > startTime1) {
            if(self.voicePitch - self.songPitch > 0.01) {
                DispatchQueue.main.async {
                    self.koreanLirics1.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[index*2], attributes: self.pitchTextAttributes)
                    self.pitchCount -= 1
                    self.pitchCountLabel.text = String(self.pitchCount)
                    self.showToast(message: "음정을 틀리셨어요🥲")
                }

            } else {
                
                DispatchQueue.main.async {
                    self.koreanLirics1.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[index*2], attributes: self.strokeTextAttributes)
                }
                
                
            }
        }
    }
    func pitchCheck2(index : Int, startTime2: String, endTime2:String, currentTime : String) {
       
        let startTime2 = self.convertString2Time(startTime2)
        let endTime2 = self.convertString2Time(endTime2)
        let currentTime = self.convertString2Time(currentTime)
        if (currentTime < endTime2 && currentTime > startTime2) {
            if(self.voicePitch - self.songPitch > 0.01) {
                DispatchQueue.main.async {
                    if (index < self.lyrics.startLyricsTime1.count - 1 ) {
                        self.koreanLirics2.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[index*2+1], attributes: self.pitchTextAttributes)
                        self.pitchCount -= 1
                        self.pitchCountLabel.text = String(self.pitchCount)
                        self.showToast(message: "음정을 틀리셨어요🥲")
                    }

                }

            } else {
                
                DispatchQueue.main.async {
                    if (index < self.lyrics.startLyricsTime1.count - 1 ) {
                        self.koreanLirics2.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[index*2+1], attributes: self.strokeTextAttributes)
                    }
                    
                }
                
                
            }
        }
    }


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
            DispatchQueue.main.async { [self] in
                self.koreanLirics1.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+2], attributes: defaultTextAttributes)
                self.koreanLirics2.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+1], attributes: strokeTextAttributes)
                
            }
        }
    }
    func endTimeCheck2(_ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics2.textColor = .white
        }
    }
    func convertNSTimeInterval2String(_ time:Float
    ) -> String {
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
        //print("real time : \(result)")
        return result
    }
    /*
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
     */
    func playAudio() {
        audioPlayer.play()
        //playTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    func getSongPitch() -> Double {
        let power = audioPlayer?.averagePower(forChannel: 0) ?? -160.0 // default value if audio player is nil
        let pitch = pow(10, (0.05 * Double(power))) * referenceFrequency
        return pitch
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
        self.navigationController?.pushViewController(feedbackVC, animated: true)
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
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
    }
    
    @objc func updateRecordTime() {
        let currentTime = convertNSTimeInterval2String(Float(audioRecorder.currentTime))
        print("record time : \(currentTime)")
        
    }
}
