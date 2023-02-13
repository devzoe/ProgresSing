//
//  VocalLessonViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/13.
//

import UIKit

class VocalLessonViewController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let imageView: UIImageView = {
            let aImageView = UIImageView()
            
            //표시될 UIImage 객체 부여
            aImageView.image = UIImage(named: "lessonBackground")
            aImageView.translatesAutoresizingMaskIntoConstraints = false
            return aImageView
        }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.backgroundImageView.image = UIImage(named: "")
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Device.width),
            imageView.heightAnchor.constraint(equalToConstant: Device.height),
        ])
        self.imageView.transform = self.imageView.transform.rotated(by: .pi/2 * 3) // 90도는 π/2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.addObservers()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        appDelegate.shouldSupportAllOrientation = true
        self.removeObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.detectOrientation), name: NSNotification.Name("UIDeviceOrientationDidChangeNotification"), object: nil)
    }
        
    func removeObservers() {
        NotificationCenter.default.removeObserver(NSNotification.Name("UIDeviceOrientationDidChangeNotification"))
    }
        
    /// 디바이스 회전 감지 함수
    @objc func detectOrientation() {
        if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
            print("회전 감지 : landscapeLeft")
            // some code ...
            
        } else if (UIDevice.current.orientation == .portrait) || (UIDevice.current.orientation == .portraitUpsideDown) {
            print("회전 감지 : portrait")
            // some code ...
        }
    }
    
}
