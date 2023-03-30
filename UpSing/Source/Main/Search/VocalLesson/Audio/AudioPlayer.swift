//
//  AudioPlayerr.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/17.
//

import Foundation

import AVFoundation

class AudioPlayer {
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()
    let audioFile: AVAudioFile
    var audioBuffer: AVAudioPCMBuffer?
    var playTimer = Timer()
    let timePlayerSelector:Selector = #selector(AudioPlayer.updatePlayTime)
    
    let lyrics : Lyrics = Lyrics()

    init(audioFile: AVAudioFile) {
        self.audioFile = audioFile
        do {
            let audioFormat = audioFile.processingFormat
            let audioFrameCount = UInt32(audioFile.length)
            audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            try audioFile.read(into: audioBuffer!)
        } catch {
            print("Error reading audio file: \(error.localizedDescription)")
        }
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioBuffer!.format)
        try! audioEngine.start()
    }
    
    func play() {
        audioPlayerNode.play()
        playTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    func stop() {
        audioPlayerNode.stop()
        playTimer.invalidate()
    }
    
    @objc func updatePlayTime() {
        if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime)
        {
            let currentTime = Float(playerTime.sampleTime) / Float(playerTime.sampleRate)
            print("Current time: \(currentTime)")
        }
    }


}

