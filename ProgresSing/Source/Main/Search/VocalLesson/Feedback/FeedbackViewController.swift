//
//  FeedbackViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/16.
//

import UIKit
import FloatingPanel

class FeedbackViewController: BaseViewController, FloatingPanelControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lyric : Lyrics = Lyrics()
    
    var pitchCount = 0
    var vocalFryCount = 0
    var beltCount = 0
    var vibratoCount = 0
    
    var fpc: FloatingPanelController!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var pitchScoreLabel: UILabel!
    @IBOutlet weak var beltScoreLabel: UILabel!
    @IBOutlet weak var vibratoScoreLabel: UILabel!
    @IBOutlet weak var vocalFryScoreLabel: UILabel!
    
    @IBOutlet weak var shareView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appDelegate.shouldSupportAllOrientation = true
        self.navigationController?.navigationBar.isHidden = false
        self.homeButton.setCornerRadius2(10)
        self.calculateScore()
    }
    
    func calculateScore() {
        let pitchTotalCount = 469
        let beltTotalCount = self.lyric.beltTime.count
        let vibratoTotalCount = self.lyric.vibratoTime.count
        let vocalFryTotalCount = self.lyric.vocalFryTime.count + 7
        

        let pitchScore = Float(pitchTotalCount+pitchCount)/Float(pitchTotalCount) * 100
        let beltScore = Float(beltCount)/Float(beltTotalCount) * 100
        let vibratoScore = Float(vibratoCount)/Float(vibratoTotalCount) * 100
        let vocalFryScore = Float(vocalFryCount)/Float(vocalFryTotalCount) * 100
        
        self.pitchScoreLabel.text = String(format: "%.2f", pitchScore)
        self.beltScoreLabel.text = String(format: "%.2f",beltScore)
        self.vibratoScoreLabel.text = String(format: "%.2f",vibratoScore)
        self.vocalFryScoreLabel.text = String(format: "%.2f",vocalFryScore)
        
        let finalScore = (pitchScore+beltScore+vibratoScore+vocalFryScore) / 4
        self.finalScoreLabel.text = String(format: "%.2f",finalScore)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func homeButtonTouchUpInside(_ sender: Any) {
        let mainTabBarController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        changeRootViewController(mainTabBarController)
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender: Any) {
        self.setupView()
    }
    private func setupView() {
        let bottomSheetVC = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        bottomSheetVC.shareView = self.shareView
        fpc = FloatingPanelController()
        fpc.changePanelStyle() // panel 스타일 변경 (대신 bar UI가 사라지므로 따로 넣어주어야함)
        fpc.delegate = self
        // 1
        //bottomSheetVC.modalPresentationStyle = .overFullScreen
        
        
        
        fpc.set(contentViewController: bottomSheetVC)
        fpc.addPanel(toParent: self)
        
        //floatingPaneldesign()
        
        //fpc.show()
        fpc.layout = CustomFloatingPanelLayout()
    }
    
    
}

class CustomFloatingPanelLayout: FloatingPanelLayout{
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .tip
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .superview),
                .half: FloatingPanelLayoutAnchor(absoluteInset: 270.0, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: 110.0, edge: .bottom, referenceGuide: .superview)
            ]
        }
}

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: -4.0)
        shadow.opacity = 0.15
        shadow.radius = 2
        appearance.shadows = [shadow]
        appearance.cornerRadius = 15.0
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0

        surfaceView.grabberHandle.isHidden = true
        surfaceView.appearance = appearance

    }
}

extension FeedbackViewController {
    // 특정 속도로 아래로 당겼을때 dismiss 되도록 처리
    public func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        guard velocity.y > 50 else { return }
        dismiss(animated: true)
    }
}
