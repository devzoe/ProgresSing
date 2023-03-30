//
//  UIFont.swift
//  Javis
//
//  Created by 남경민 on 2023/02/07.
//

import Foundation
import UIKit

extension UIFont {
    public enum IcelandType: String {
        //case bold = "Bold"
        //case medium = "Medium"
        case regular = "Regular"
    }

    static func Iceland(_ type: IcelandType, size: CGFloat) -> UIFont {
        return UIFont(name: "Iceland-\(type.rawValue)", size: size)!
    }
}
