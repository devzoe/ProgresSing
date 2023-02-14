//
//  AudioController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/14.
//

import AVFoundation

class AudioController {
    var audioEngine = AVAudioEngine()
    var audioPlayerNode = AVAudioPlayerNode()
    var audioFile: AVAudioFile?
    
    let sampleRate: Double = 44100
    let yinThreshold: Double = 0.1
    let yinBufferLength: Int = 1024
    /*
    func playAndCheckPitch() {
        audioFile = try! AVAudioFile(forReading: URL(fileURLWithPath: "path/to/audiofile.mp3"))
        
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFile?.processingFormat)
        
        try! audioEngine.start()
        audioPlayerNode.play()
        
        let yin = YIN(sampleRate: sampleRate, threshold: yinThreshold, bufferSize: yinBufferLength)
        
        audioPlayerNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(yinBufferLength), format: audioFile?.processingFormat) { (buffer, time) in
            let floatArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:Int(buffer.frameLength)))
            
            if let pitch = yin.getPitch(floatArray) {
                print("Current pitch: \(pitch) Hz")
            }
        }
    }
     */
}






