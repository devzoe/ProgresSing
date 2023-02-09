//
//  UIButton.swift
//  Javis
//
//  Created by 남경민 on 2023/02/09.
//

import UIKit

extension UIButton {
    func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
    }
}
