//
//  UIColor.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/19.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var progressingPuple: UIColor { UIColor(hex: 0x7667E6) }
    
    class var lyricSkyBlue : UIColor { UIColor(hex: 0x51E3EC)}
    
    class var labelFalse : UIColor { UIColor(hex: 0x262626)}
    
    class var belt : UIColor { UIColor(hex: 0xED9837)}
    
    class var beltEnableFalse : UIColor { UIColor(hex: 0x241603)}
    
    class var vibratoEnableFalse : UIColor { UIColor(hex: 0x1B1F0D)}
    
    class var vibrato : UIColor { UIColor(hex: 0xB7D25B)}
    
    class var vocalFry : UIColor { UIColor(hex: 0x9E8CCC)}
    
    class var vocalFryEnableFalse : UIColor { UIColor(hex: 0x18151F)}
    
}
