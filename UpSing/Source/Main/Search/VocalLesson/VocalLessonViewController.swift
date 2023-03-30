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
import Accelerate


class VocalLessonViewController: BaseViewController {
    lazy var vocalLessonDataManager = VocalLessonDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // 레코드 객체 생성 - 데이터를 가져오기 위함
    private var recordService: MyRecordViewModel = MyRecordViewModel.shared
    
    let lyrics : Lyrics = Lyrics()
    
    let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.lyricSkyBlue,
        NSAttributedString.Key.foregroundColor : UIColor.lyricSkyBlue,
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
        NSAttributedString.Key.foregroundColor : UIColor.red,
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
    var vocalFryCount : Int = 0
    
    @IBOutlet weak var BeltButton: UIButton!
    @IBOutlet weak var beltCountLabel: UILabel!
    var beltCount : Int = 0
    
    @IBOutlet weak var vibratoButton: UIButton!
    @IBOutlet weak var vibratoCountLabel: UILabel!
    var vibratoCount : Int = 0
    
    
    @IBOutlet var vocalFryCollection : [UIButton]!
    @IBOutlet var vibratoCollection : [UIButton]!
    @IBOutlet var beltCollection : [UIButton]!
    
    var songPitch : Float = 0
    var voicePitch : Float = 0
    
    
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()
    var audioBuffer: AVAudioPCMBuffer?
    var audioFileURL : URL!
    var audioFile : AVAudioFile!
    var audioFormat :AVAudioFormat!
    
    // Attach audio input node for voice recording
    var audioInputNode : AVAudioInputNode!
    var audioInputFormat : AVAudioFormat!
    //Mixer to mix 1K with mic input during recording
    var mixerNode : AVAudioMixerNode!
    var recordPath : URL?
    var recordFile : AVAudioFile!
    
    var labelArray : [String] = []
    
    var prevRMSValue : Float = 0.3
    //fft setup object for 1024 values going forward (time domain -> frequency domain)
    let fftSetup = vDSP_DFT_zop_CreateSetup(nil, 1024, vDSP_DFT_Direction.FORWARD)
    let model = try! vocal_trained_model(configuration: MLModelConfiguration())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            //print("Check1 : \(Thread.current)")
            self.navigationController?.navigationBar.isHidden = true
            self.backgroundImageView.image = UIImage(named: "lessonBackground")
            self.backgroundImageView.transform = self.backgroundImageView.transform.rotated(by: .pi/2 * 3)
            self.koreanLirics1.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[0], attributes: self.defaultTextAttributes)
            self.koreanLirics2.attributedText = NSMutableAttributedString(string: self.lyrics.koreanLyrics[1], attributes: self.defaultTextAttributes)
            self.pitchButton.setCornerRadius2(10)
            self.vocalFryButton.setCornerRadius2(10)
            self.BeltButton.setCornerRadius2(10)
            self.vibratoButton.setCornerRadius2(10)
            
            for i in self.vocalFryCollection {
                i.setCornerRadius2(10)
            }
            for i in self.vibratoCollection {
                i.setCornerRadius2(10)
            }
            for i in self.beltCollection {
                i.setCornerRadius2(10)
            }
  
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            //print("check2 : \(Thread.current)")
            self.initPlay()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate.shouldSupportAllOrientation = true
        self.stop()
    }
    
    // MARK: back button
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        let mainTabBarController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        changeRootViewController(mainTabBarController)
    }
    
}

// MARK: audio play

extension VocalLessonViewController {
    func initPlay() {
        // Connect audio player and time pitch node to audio engine's output node
        
        
        //self.mixerNode = AVAudioMixerNode()
        //self.audioEngine.attach(mixerNode)
        
        // MARK: Set up Audio Session
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        //audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        try! audioSession.setActive(true)
        //audioPlayerNode.volume = 1.0
        //self.audioEngine.connect(audioInputNode, to: self.mixerNode, format: inputFormat)
        //Connect mixer to mainMixer
        //self.audioEngine.connect(self.mixerNode, to: self.audioEngine.mainMixerNode, format: inputFormat)
        
        // Start music playback

        //Tap on the mixer output (MIXER HAS BOTH MICROPHONE AND 1K.mp3)
        /* self.mixerNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount((inputFormat.sampleRate)! * 0.4), format: inputFormat, block: { (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
         
         
         })*/
        self.audioFileURL = Bundle.main.url(forResource: "Fine-Melody", withExtension: "mp3")!
        self.audioFile = try! AVAudioFile(forReading: audioFileURL)
        self.audioFormat = audioFile.processingFormat
        print("play format : \(audioFormat)")
        self.audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
        try! self.audioFile.read(into: audioBuffer!)
        
        self.audioEngine.attach(audioPlayerNode)
        self.audioEngine.connect(audioPlayerNode, to: audioEngine.outputNode, format: audioFormat)
        
        self.audioInputNode = audioEngine.inputNode
        let inputFormat = audioInputNode.inputFormat(forBus: 0)
        audioPlayerNode.scheduleBuffer(audioBuffer!) {
            self.stop()
        }
        let bus = 0
        let sampleRate = audioEngine.inputNode.inputFormat(forBus: 0).sampleRate
        let timeInterval = 1.0
        print("sample rate :\(UInt32(audioEngine.inputNode.inputFormat(forBus: 0).sampleRate))")
        print("format : \(audioEngine.inputNode.inputFormat(forBus: 0))")
        print("input data : \(audioEngine.inputNode.inputFormat(forBus: 0).formatDescription)")
        let bufferSize = AVAudioFrameCount(sampleRate * timeInterval)
        print("buffer size : \(bufferSize)")
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
        self.audioInputNode.installTap(onBus: 1, bufferSize: bufferSize, format: format) { [self] (buffer, time) in
            let voicePitch = self.processAudioData(buffer: buffer)
            
            
            //print("voice Pitch : \(voicePitch)")
            //print("buffer : \(buffer.stride)")
            print("buffer : \(buffer.frameLength)")
            print("buffer : \(buffer.frameCapacity)")
            
            var pointer = buffer.floatChannelData?.pointee
            
            //for i in 0...buffer.frameLength {
            //    print("buffer : \(pointer![Int(i)])")
            //}
            print("record time : \(time)")

            print("record time : \(time.sampleRate)")
            //print("record time : \(time.audioTimeStamp)")
           // print("record time : \(time.sampleTime)")
            //print("record time : \(self.audioInputNode.lastRenderTime)")

            DispatchQueue.main.async {
                self.voicePitch = voicePitch
            }
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime)
            {
                let currentTime = Float(playerTime.sampleTime) / Float(playerTime.sampleRate)
                //print("record time : \(currentTime)")
                let currentTime1 = Int(currentTime)
                for i in self.lyrics.vocalFryTime {
                    if (Int(i) == currentTime1) {
                        DispatchQueue.global().async {
                            self.processBuffer("vocal_fry",buffer)
                        }
                    }
                }
                for i in self.lyrics.vocalFryTime {
                    
                    if( Int(i)+1 != 18 ){
                        if (Int(i)+1 == currentTime1) {
                            DispatchQueue.main.async {
                                if( self.labelArray.contains("True") ){
                                    self.vocalFryCount += 1
                                    self.vocalFryCountLabel.text = String(vocalFryCount)
                                    self.labelArray = []
                                }
                            }
                        }
                    }
                }
                for i in self.lyrics.vibratoTime {
                    if (Int(i) == currentTime1) {
                        DispatchQueue.global().async {
                            self.processBuffer("vibrato",buffer)
                        }
                    }
                }
                for i in self.lyrics.vibratoTime {
                    if (Int(i)+1 == currentTime1) {
                        DispatchQueue.main.async {
                            if( self.labelArray.contains("True") ){
                                self.vibratoCount += 1
                                self.vibratoCountLabel.text = String(vibratoCount)
                                self.labelArray = []
                            }
                        }
                    }
                }
                
                for i in self.lyrics.beltTime {
                    if (Int(i) == currentTime1) {
                        DispatchQueue.global().async {
                            self.processBuffer("belt",buffer)
                        }
                    }
                }
                for i in self.lyrics.beltTime {
                    if (Int(i)+1 == currentTime1) {
                        DispatchQueue.main.async {
                            if( self.labelArray.contains("True") ){
                                self.beltCount += 1
                                self.beltCountLabel.text = String(beltCount)
                                self.labelArray = []
                            }
                        }
                    }
                }
                
            }
            
            do{
                // Write the audio buffer to a file
                if self.recordFile == nil {
                    // Create an audio file and write the header
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileName = "recordedAudioFile.wav"
                    let fileURL = documentsURL.appendingPathComponent(fileName)
                    self.recordPath = fileURL
                    self.recordFile = try AVAudioFile(forWriting: fileURL, settings: inputFormat.settings)
                    try self.recordFile?.write(from: buffer)
                } else {
                    // Append the buffer to the audio file
                    try self.recordFile?.write(from: buffer)
                }
            } catch {
                print("Error writing audio buffer: \(error.localizedDescription)")
            }
            
            
        }
        
        self.audioPlayerNode.installTap(onBus: bus, bufferSize: 1024, format : audioFormat) { (buffer, time) in
            let songPitch = self.processAudioData(buffer: buffer)
            //print("song Pitch : \(songPitch)")
            //print("play time : \(time)")
            DispatchQueue.main.async {
                self.songPitch = songPitch
            }
            DispatchQueue.global().async {
                if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime)
                {
                    var currentTime = Float(playerTime.sampleTime) / Float(playerTime.sampleRate)
                    let currentTimeString = self.convertNSTimeInterval2String(currentTime)
                    //print("Current time: \(currentTime)")
                    
                    if(currentTime > 206) {
                        self.stop()
                    }
                    
                    for i in 0..<self.lyrics.startLyricsTime1.count {
                        self.startTimeCheck1(i, self.lyrics.startLyricsTime1[i], currentTime: currentTimeString)
                        self.endTimeCheck1(i,self.lyrics.endLyricsTime1[i], currentTime: currentTimeString)
                        self.pitchCheck1(index: i, startTime1: self.lyrics.startLyricsTime1[i], endTime1: self.lyrics.endLyricsTime1[i], currentTime: currentTimeString)
                        if (i < self.lyrics.startLyricsTime2.count) {
                            
                            self.startTimeCheck2(i, self.lyrics.startLyricsTime2[i], currentTime: currentTimeString)
                            self.endTimeCheck2(i,self.lyrics.endLyricsTime2[i], currentTime: currentTimeString)
                            
                            self.pitchCheck2(index: i, startTime2:  self.lyrics.startLyricsTime2[i], endTime2: self.lyrics.endLyricsTime2[i], currentTime: currentTimeString)
                        }
                        
                    }
                }
            }
        }
        
        try! audioEngine.start()
        audioPlayerNode.play()
        // Observe changes to the system's audio output volume
        
        
        // Wait for music playback to finish
        
        
        /*
         while audioPlayerNode.isPlaying {
         RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
         //print("run roop")
         }
         */
    }
    // Handle changes to the system's audio output volume
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            // Get the new volume value
            let volume = change?[.newKey] as? Float ?? 0.0
            
            // Set the player node's volume to the new value
            audioPlayerNode.volume = volume
        }
    }
    
    func returnVocalFryIndex(startTime : Float, endTime: Float) -> [Int] {
        var index : [Int] = []
        for (i,time) in self.lyrics.vocalFryTime.enumerated() {
            if(startTime <= time && time <= endTime) {
                index.append(i)
                //print("fry index : \(i) fry time : \(time)")
            }
            
        }
        return index
    }
    func returnVibratoIndex(startTime : Float, endTime: Float) -> [Int] {
        var index : [Int] = []
        for (i,time) in self.lyrics.vibratoTime.enumerated() {
            if(startTime <= time && time <= endTime) {
                index.append(i)
                //print("vibrato index : \(i) vibrato time : \(time)")
            }
        }
        return index
    }
    func returnBeltIndex(startTime : Float, endTime: Float) -> [Int] {
        var index : [Int] = []
        for (i,time) in self.lyrics.beltTime.enumerated() {
            if(startTime <= time && time <= endTime) {
                index.append(i)
                //print("belt index : \(i) belt time : \(time)")
            }
            
        }
        return index
    }
    func processBuffer(_ label : String, _ buffer: AVAudioPCMBuffer) {
        print("process buffer : \(buffer.frameLength)")
        guard let recordingFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: Double(17640),
            channels: 1,
            interleaved: true
        ), let formatConverter = AVAudioConverter(from:audioEngine.inputNode.inputFormat(forBus: 0), to: recordingFormat) else { return }
        guard let pcmBuffer = AVAudioPCMBuffer(
            pcmFormat: recordingFormat,
            frameCapacity: AVAudioFrameCount(recordingFormat.sampleRate)
        ) else { return }
        
        var error: NSError?
        let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
            outStatus.pointee = AVAudioConverterInputStatus.haveData
            return buffer
        }
        
        formatConverter.convert(to: pcmBuffer, error: &error, withInputFrom: inputBlock)
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        //var isolatedBuffer = self.isolateVoice(buffer: pcmBuffer)
        if let channelData = pcmBuffer.floatChannelData {
            let channelDataValue = channelData.pointee
            let channelDataValueArray = stride(
                from: 0,
                to: Int(pcmBuffer.frameLength),
                by: buffer.stride
            ).map { channelDataValue[$0] }
            
            
            let vocalLessonRequest = VocalLessonRequest(data: channelDataValueArray, label: label)
            self.vocalLessonDataManager.predict(parameters: vocalLessonRequest, delegate: self)
            
            //print("channelDataValue : \(channelDataValueArray)")
            /*
            let mean = Float(channelDataValueArray.reduce(0,+))/Float(channelDataValueArray.count)
            let std = self.standardDeviation(arr: channelDataValueArray)
            print("converted buffer : \(channelDataValueArray.count)")
            
            var newArray = stride(
                from: 0,
                to: Int(pcmBuffer.frameLength),
                by: 1
            ).map { channelDataValue[$0] - mean / std }
            
            var p : UnsafeMutableRawPointer = UnsafeMutableRawPointer(&newArray)
            
            //var input : [Float]
            let input = try! MLMultiArray(dataPointer: p, shape: [1,44100,1], dataType: .float32, strides: [1,1,1])
            let prediction = try! model.prediction(conv1d_33_input: input)
            // Pass the input data to the model
            
            // Get the output result
            let output = prediction.Identity
            var outputArray : [Double] = []
            for i in 0..<output.count {
                outputArray.append(output[i].doubleValue)
            }
            
            let maxIndex = self.getMaxIndex(output)
            //print("max Index: \(maxIndex)")
            
            //outputArray.remove(at: maxIndex)
            //let secondMax = outputArray.max()
            //let secondIndex = outputArray.firstIndex(of: secondMax!)
            self.labelArray.append(maxIndex)
            //self.labelArray.append(secondIndex!)
            // Update the UI with the output result
            DispatchQueue.main.async {
                // Update the UI with the output value
                //print("model output : \(output)")
                //print("fft magnitudes : \(fftMagnitudes)")
                //print("input : \(input)")
                //print(output)
                switch maxIndex {
                case 0:
                    print("label : \(label), prediction : belt, probability : belt-\(outputArray[0]), vibrato-\(outputArray[2]), vocal fry-\(outputArray[3])")
                    print("\n")
                case 1:
                    print("label : \(label), prediction : straight, probability : belt-\(outputArray[0]), vibrato-\(outputArray[2]), vocal fry-\(outputArray[3])")
                    print("\n")
                case 2:
                    print("label : \(label), prediction : vibrato, probability : belt-\(outputArray[0]), vibrato-\(outputArray[2]), vocal fry-\(outputArray[3])")
                    print("\n")
                case 3:
                    print("label : \(label), prediction : vocal fry, probability : belt-\(outputArray[0]), vibrato-\(outputArray[2]), vocal fry-\(outputArray[3])")
                    print("\n")
                default:
                    print("default")
                }
            }
             */
        }
    }
/*
    func isolateVoice(buffer : AVAudioPCMBuffer) -> AVAudioPCMBuffer {
        let sampleCount = buffer.frameLength
        let channelCount = Int(buffer.format.channelCount)

        let samples = buffer.floatChannelData!
        var magnitudes = [Float](repeating: 0.0, count: Int(sampleCount))
        
        vDSP_vdist(samples[0], 1, samples[1], 1, &magnitudes, 1, vDSP_Length(sampleCount))

        var normalizedMagnitudes = [Float](repeating: 0.0, count: Int(sampleCount))
        vDSP_vsmul(magnitudes, 1, [2.0 / Float(sampleCount)], &normalizedMagnitudes, 1, vDSP_Length(sampleCount))

        let noiseThreshold = Float(0.1) // Set noise threshold to 0.1
        var noiseMagnitudes = [Float](repeating: 0.0, count: Int(sampleCount))
        vDSP_vclr(&noiseMagnitudes, 1, vDSP_Length(sampleCount))
        vDSP_vthr(normalizedMagnitudes, 1, [noiseThreshold], &noiseMagnitudes, 1, vDSP_Length(sampleCount))
        vDSP_vsub(noiseMagnitudes, 1, normalizedMagnitudes, 1, &normalizedMagnitudes, 1, vDSP_Length(sampleCount))

        let voiceBuffer = AVAudioPCMBuffer(pcmFormat: buffer.format, frameCapacity: buffer.frameCapacity)!
        voiceBuffer.frameLength = buffer.frameLength

        let voiceSamples = voiceBuffer.floatChannelData!
        for channel in 0..<channelCount {
            vDSP_vmul(samples[channel], 1, normalizedMagnitudes, 1, voiceSamples[channel], 1, vDSP_Length(sampleCount))
        }
        return voiceBuffer
    }
*/
    func didSuccessPredict(_ response : VocalLessonResponse) {
        self.labelArray.append(response.result)
        print(labelArray)
        print("성공")
    }
    func failedToRequest(message: String) {
        //self.presentAlert(title: message)
        print(message)
    }
    
    func getMaxIndex(_ array: MLMultiArray) -> Int {
        var maxIndex = 0
        var maxValue = 0.0
        for i in 0..<array.count {
            if let value = array[i] as? Double, value > maxValue {
                maxValue = value
                maxIndex = i
            }
        }
        return maxIndex
    }
    
    func standardDeviation(arr : [Float]) -> Float
    {
        let length = Float(arr.count)
        let avg = arr.reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
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
        audioEngine.inputNode.removeTap(onBus: 0)
        audioPlayerNode.removeTap(onBus: 0)
        audioEngine.stop()
        //audioPlayerNode.stop()
        self.recordService.add(record: MyRecord(imageName: "fine", artist: "태연", title: "fine", recordURL: (self.recordPath!)))
        //print("recordpath1 :  \(self.recordPath!)")
        DispatchQueue.main.async {
            let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            feedbackVC.pitchCount = self.pitchCount
            feedbackVC.vocalFryCount = self.vocalFryCount
            feedbackVC.beltCount = self.beltCount
            feedbackVC.vibratoCount = self.vibratoCount
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
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
}

extension VocalLessonViewController: AVAudioPlayerDelegate {
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
                
                self.progress1.progress = 0.0
                
                
                
                let startTime1 = self.convertString2Time(self.lyrics.startLyricsTime1[index])
                let endTime2 : Float?
                if(index < self.lyrics.startLyricsTime1.count - 1  ) {
                    endTime2 = self.convertString2Time(self.lyrics.endLyricsTime2[index])
                } else {
                    endTime2 = self.convertString2Time(self.lyrics.endLyricsTime1[index])
                }
                let currentTime = self.convertString2Time(currentTime)
                
                let timeIndex1 = self.returnVocalFryIndex(startTime: startTime1, endTime: endTime2!)
                for i in timeIndex1 {
                    DispatchQueue.main.async {
                        self.vocalFryCollection[i].isHidden = false
                    }
                }
                let timeIndex2 = self.returnVibratoIndex(startTime: startTime1, endTime: endTime2!)
                for i in timeIndex2 {
                    DispatchQueue.main.async {
                        self.vibratoCollection[i].isHidden = false
                    }
                }
                let timeIndex3 = self.returnBeltIndex(startTime: startTime1, endTime: endTime2!)
                for i in timeIndex3 {
                    DispatchQueue.main.async {
                        self.beltCollection[i].isHidden = false
                    }
                }
                
                
                
            }
        }
    }
    func pitchCheck1(index : Int, startTime1: String, endTime1: String, currentTime : String) {
        let startTime1 = self.convertString2Time(startTime1)
        let endTime1 = self.convertString2Time(endTime1)
        let currentTime = self.convertString2Time(currentTime)
        if (currentTime < endTime1 && currentTime > startTime1) {
            if(self.voicePitch - self.songPitch > 0.1) {
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
            if(self.voicePitch - self.songPitch > 0.1) {
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
    
    
    
    func endTimeCheck1(_ index: Int, _ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics1.textColor = .white
            let startTime1 = self.convertString2Time(self.lyrics.startLyricsTime1[index])
            let endTime1 = self.convertString2Time(self.lyrics.endLyricsTime1[index])
            let currentTime = self.convertString2Time(currentTime)
            
            let timeIndex1 = self.returnVocalFryIndex(startTime: startTime1, endTime: endTime1)
            for i in timeIndex1 {
                DispatchQueue.main.async {
                    self.vocalFryCollection[i].isHidden = true
                }
            }
            let timeIndex2 = self.returnVibratoIndex(startTime: startTime1, endTime: endTime1)
            for i in timeIndex2 {
                DispatchQueue.main.async {
                    self.vibratoCollection[i].isHidden = true
                }
            }
            let timeIndex3 = self.returnBeltIndex(startTime: startTime1, endTime: endTime1)
            for i in timeIndex3 {
                DispatchQueue.main.async {
                    self.beltCollection[i].isHidden = true
                }
            }
            
            
        }
    }
    func startTimeCheck2(_ index : Int,_ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics2.textColor = .blue
            DispatchQueue.main.async { [self] in
                self.koreanLirics1.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+2], attributes: defaultTextAttributes)
                self.koreanLirics2.attributedText = NSMutableAttributedString(string: lyrics.koreanLyrics[index*2+1], attributes: strokeTextAttributes)
                
                let startTime2 = self.convertString2Time(self.lyrics.startLyricsTime2[index])
                let endTime3 = self.convertString2Time(self.lyrics.endLyricsTime1[index+1])
                let currentTime = self.convertString2Time(currentTime)
                
                let timeIndex1 = self.returnVocalFryIndex(startTime: startTime2, endTime: endTime3)
                for i in timeIndex1 {
                    DispatchQueue.main.async {
                        self.vocalFryCollection[i].isHidden = false
                    }
                }
                let timeIndex2 = self.returnVibratoIndex(startTime: startTime2, endTime: endTime3)
                for i in timeIndex2 {
                    DispatchQueue.main.async {
                        self.vibratoCollection[i].isHidden = false
                    }
                }
                let timeIndex3 = self.returnBeltIndex(startTime: startTime2, endTime: endTime3)
                for i in timeIndex3 {
                    DispatchQueue.main.async {
                        self.beltCollection[i].isHidden = false
                    }
                }
                
                
            }
        }
    }
    func endTimeCheck2(_ index: Int, _ lyricsTime: String, currentTime : String) {
        if (lyricsTime == currentTime) {
            //self.koreanLirics2.textColor = .white
            let startTime2 = self.convertString2Time(self.lyrics.startLyricsTime2[index])
            let endTime2 = self.convertString2Time(self.lyrics.endLyricsTime2[index])
            let currentTime = self.convertString2Time(currentTime)
            
            let timeIndex1 = self.returnVocalFryIndex(startTime: startTime2, endTime: endTime2)
            for i in timeIndex1 {
                DispatchQueue.main.async {
                    self.vocalFryCollection[i].isHidden = true
                }
            }
            let timeIndex2 = self.returnVibratoIndex(startTime: startTime2, endTime: endTime2)
            for i in timeIndex2 {
                DispatchQueue.main.async {
                    self.vibratoCollection[i].isHidden = true
                }
            }
            let timeIndex3 = self.returnBeltIndex(startTime: startTime2, endTime: endTime2)
            for i in timeIndex3 {
                DispatchQueue.main.async {
                    self.beltCollection[i].isHidden = true
                }
            }
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
    
}
