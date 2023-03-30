//
//  YIN.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/17.
//

import Foundation
import AVFoundation

class YIN {
    var audioBuffer: AVAudioPCMBuffer
    var threshold: Float = 0.1
    var probabilityThreshold: Float = 0.1
    var pitch : Float = 0
    
    init(audioBuffer: AVAudioPCMBuffer) {
        self.audioBuffer = audioBuffer
    }

    func calculatePitch() {
        let frameCount = Int(audioBuffer.frameLength)
        let resultCount = frameCount / 2
        var yinBuffer = [Float](repeating: 0, count: resultCount)
        let probability = [Float](repeating: 0, count: resultCount)

        // Step 1: Calculate the difference function
        for tau in 0..<resultCount {
            for i in 0..<resultCount {
                let delta = audioBuffer.floatChannelData![0][i] - audioBuffer.floatChannelData![0][i + tau]
                yinBuffer[tau] += delta * delta
            }
        }

        // Step 2: Calculate the cumulative mean normalized difference function
        var runningSum: Float = 0
        yinBuffer[0] = 1
        for tau in 1..<resultCount {
            runningSum += yinBuffer[tau - 1]
            yinBuffer[tau] *= Float(tau) / runningSum
        }

        // Step 3: Find the first local minimum above the threshold
        for tau in 2..<resultCount {
            if yinBuffer[tau] < threshold {
                var foundMinimum = true
                for j in 1..<5 {
                    if yinBuffer[tau] >= yinBuffer[tau - j] || yinBuffer[tau] >= yinBuffer[tau + j] {
                        foundMinimum = false
                        break
                    }
                }
                if foundMinimum {
                    // Step 4: Refine the pitch estimate using parabolic interpolation
                    let t0 = tau - 1
                    let t1 = tau
                    let t2 = tau + 1
                    let r0 = yinBuffer[t0]
                    let r1 = yinBuffer[t1]
                    let r2 = yinBuffer[t2]
                    let a = (r0 + r2 - 2 * r1) / 2
                    let b = (r2 - r0) / 2
                    let tauEstimate = Float(t1) + b / (2 * a)
                    if r1 < probabilityThreshold {
                        continue
                    }
                    self.pitch = Float(audioBuffer.format.sampleRate) / tauEstimate
                    return
                }
            }
        }
        // Step 5: No pitch estimate found
        self.pitch = 0
    }

    func getPitch() -> Float {
        return self.pitch
    }
}
