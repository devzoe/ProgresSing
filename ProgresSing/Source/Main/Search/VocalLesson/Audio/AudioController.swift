//
//  AudioController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/14.
//

import AVFoundation
import UIKit
import CoreML

class AudioController {
    var audioEngine = AVAudioEngine()
    var audioInputNode: AVAudioInputNode?
    let model = try! new_model2(configuration: MLModelConfiguration())
    
    func startCapturingAudio() {
        audioInputNode = audioEngine.inputNode
        
        let audioFormat = audioInputNode?.outputFormat(forBus: 0)
        audioInputNode?.installTap(onBus: 0, bufferSize: 1024, format: audioFormat) { buffer, time in
            do{
                let audioData = buffer.floatChannelData![0]
                let audioDataPtr = UnsafeMutablePointer<Float>(mutating: audioData)
                let audioSamples = try MLMultiArray(dataPointer: audioDataPtr, shape: [1024], dataType: .float32, strides: [1])
                
                let modelInput = new_model2Input(conv2d_4_input: audioSamples)
                if let modelOutput = try? self.model.prediction(input: modelInput) {
                    print(modelOutput.Identity)
                }
            }catch( _){
                print("error in install Tab")
            }
        }
        
        try! audioEngine.start()
    }
    func stopCapturingAudio() {
        audioInputNode?.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
}


 








