//
//  LyricLabel.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/15.
//
import UIKit

class LyricLabel: UILabel {
    // Set progress to update the view
    private var _progress = 1
    var progress : Int {
        set{
            _progress = newValue
            self.setNeedsDisplay()
        }
        get{
            return _progress
        }
    }
    
    // Set Lyric Color & redraw immediately
    private var _color : UIColor = UIColor.blue
    var color : UIColor {
        get{
            return _color
        }
        set{
            _color = newValue
            self.setNeedsDisplay()
        }
    }
    
    private var image2Use : UIImage?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let myString: NSString = self.text! as NSString
        var size: CGSize = myString.size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: self.font.pointSize)])
        size.height = rect.height;
//        var size = rect.size;
        
         // Draw solid color filled image
        size.width = max(1, size.width * (CGFloat(progress) * 0.01))
        let image:UIImage = getImageWithColor(color: color, size: size)!
        image2Use = image
        image2Use?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.sourceAtop, alpha: 1)
    }
    
    // Get solid Image with color and size
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
