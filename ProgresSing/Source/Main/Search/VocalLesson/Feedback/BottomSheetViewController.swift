//
//  BottomSheetViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/03/15.
//

import UIKit
import FloatingPanel
import Then

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var shareInstagramView: UIStackView!
    @IBOutlet weak var shareKakaoView: UIStackView!
    
    weak var shareView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        var shareInstagram = UITapGestureRecognizer(target: self, action: #selector(self.shareInstagram(gesture:)))
        self.shareInstagramView.addGestureRecognizer(shareInstagram)
        
        var shareKakao = UITapGestureRecognizer(target: self, action: #selector(self.shareKakao(gesture:)))
        self.shareKakaoView.addGestureRecognizer(shareKakao)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func shareInstagram(gesture: UITapGestureRecognizer) {
        if let storyShareURL = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storyShareURL)
            {
                let renderer = UIGraphicsImageRenderer(size: shareView.bounds.size)
                
                let renderImage = renderer.image { _ in
                    shareView.drawHierarchy(in: shareView.bounds, afterScreenUpdates: true)
                }
                
                
                guard let imageData = renderImage.pngData() else {return}
                
                
                
                let pasteboardItems : [String:Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor" : "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor" : "#b2bec3",
                    
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
                ]
                
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                
                
                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
            }
            else
            {
                let alert = UIAlertController(title: "알림", message: "인스타그램이 필요합니다", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc func shareKakao(gesture: UITapGestureRecognizer) {
        
        
    }
    
    
    
}
