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
    /*
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
     let audioSamples = try MLMultiArray(dataPointer: audioDataPtr, shape: [1, 128, 259, 1], dataType: .float32, strides: [1])
     
     let modelInput = new_model2Input(conv2d_4_input: audioSamples)
     if let modelOutput = try? self.model.prediction(input: modelInput) {
     print(modelOutput.Identity)
     }
     } catch( _){
     print("error in install Tab")
     }
     }
     
     try! audioEngine.start()
     }
     func stopCapturingAudio() {
     audioInputNode?.removeTap(onBus: 0)
     audioEngine.stop()
     }
     */
    
    var audioEngine: AVAudioEngine!
    var inputNode: AVAudioInputNode!
    //var model: MLModel!
    //let model = try! new_model2(configuration: MLModelConfiguration())
    var bufferSize: AVAudioFrameCount = 1024
    var analysisFormat: AVAudioFormat!
    var analysisQueue: DispatchQueue!
    var analysisBuffer: AVAudioPCMBuffer!
    
    func startCapturingAudio() {        // Load the Core ML model
        //let modelPath = Bundle.main.path(forResource: "new_model2", ofType: "mlmodel")!
        //let modelURL = URL(fileURLWithPath: modelPath)
        //model = try! MLModel(contentsOf: modelURL)
        
        // Set up the AVAudioEngine to record the user's voice in real time
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        analysisFormat = AVAudioFormat(standardFormatWithSampleRate: inputNode.outputFormat(forBus: 0).sampleRate, channels: 1)
        analysisQueue = DispatchQueue(label: "com.example.analysisQueue")
        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: analysisFormat) { buffer, time in
            self.analysisQueue.async {
                self.processBuffer(buffer)
            }
        }
        
        // Start the audio engine
        try! audioEngine.start()

    }
            
    
    func processBuffer(_ buffer: AVAudioPCMBuffer) {
        // Prepare the input data for the model
        let audioData = buffer.floatChannelData![0]
        let audioDataPtr = UnsafeMutablePointer<Float>(mutating: audioData)
        let input = try! MLMultiArray(dataPointer: audioDataPtr, shape: [1,128,259,1], dataType: .float32, strides: [1,1,1,1])
        //for i in 0..<buffer.frameLength {
         //   input[i] = Float(buffer.floatChannelData!.pointee[Int(i)]) / 32768.0
        //}
        
        // Pass the input data to the model
        //let prediction = try! model.prediction(input: new_model2Input(conv2d_4_input: input))
        
        // Get the output result
        //let output = prediction.Identity
        
        // Update the UI with the output result
        DispatchQueue.main.async {
            // Update the UI with the output value
           // print("model output : \(output)")
        }
    }
    
    func stopRecording() {
        // Stop the audio engine and the recorder
        audioEngine.stop()
    }
}













