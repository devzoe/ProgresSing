//
//  BottomSheetViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/03/15.
//

import UIKit
import FloatingPanel
import Then

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKShare
import KakaoSDKTemplate
import SafariServices

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var shareInstagramView: UIStackView!
    @IBOutlet weak var shareKakaoView: UIStackView!
    var imageUrl : String = ""
    
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
    func viewToImage() {
        let renderer = UIGraphicsImageRenderer(size: shareView.bounds.size)
        
        let renderImage = renderer.image { _ in
            shareView.drawHierarchy(in: shareView.bounds, afterScreenUpdates: true)
        }
        //let resizedImage = self.resizeImage(image: renderImage, newWidth: 100)!
        FirebaseStorageManager.uploadImage(image: renderImage, pathRoot: "image") { url in
            if let url = url {
                //UserDefaults.standard.set(url.absoluteString, forKey: "myImageUrl")
                //self.title = "이미지 업로드 완료"
                self.imageUrl = url.absoluteString
            }
        }
    }
    @objc func shareKakao(gesture: UITapGestureRecognizer) {
        self.viewToImage()
        
        self.showIndicator()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
          // 5초 후 실행될 부분
            self.dismissIndicator()
            if ShareApi.isKakaoTalkSharingAvailable(){
                
                // Web Link로 전송이 된다. 하지만 우리는 앱 링크를 받을거기 때문에 딱히 필요가 없으.
                // 아래 줄을 주석해도 상관없다.
                print("\(self.imageUrl)")
                //let link = Link(webUrl: URL(string:"\(self.imageUrl)"),
                               // mobileWebUrl: URL(string:"\(self.imageUrl)"))
                
                // 우리가 원하는 앱으로 보내주는 링크이다.
                // second, vvv는 url 링크 마지막에 딸려서 오기 때문에, 이 파라미터를 바탕으로 파싱해서
                // 앱단에서 원하는 기능을 만들어서 실행할 수 있다 예를 들면 다른 뷰 페이지로 이동 등등~
                let appLink = Link(iosExecutionParams: ["second": "vvv"])

                // 해당 appLink를 들고 있을 버튼을 만들어준다.
                let button = Button(title: "점수 보기", link: appLink)
                
                // Content는 이제 사진과 함께 글들이 적혀있다.
                let content = Content(title: "UpSing Vocal Score 보기",
                                      imageUrl: URL(string: self.imageUrl)!,
                                      imageWidth: 100,
                                      imageHeight: 326,
                                    description: "#UpSing #VocalTraining #노래",
                                      link: appLink)
                
               
                // 템플릿에 버튼을 추가할때 아래 buttons에 배열의 형태로 넣어준다.
                // 만약 버튼을 하나 더 추가하려면 버튼 변수를 만들고 [button, button2] 이런 식으로 진행하면 된다 .
                let template = FeedTemplate(content: content, buttons: [button])
                
                //메시지 템플릿 encode
                if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                    
                    //생성한 메시지 템플릿 객체를 jsonObject로 변환
                    if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                        ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
                            if let error = error {
                                print("error : \(error)")
                            }
                            else {
                                print("defaultLink(templateObject:templateJsonObject) success.")
                                guard let linkResult = linkResult else { return }
                                UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            }
            else {
                print("카카오톡 미설치")
                // 카카오톡 미설치: 웹 공유 사용 권장
                // 아래 함수는 따로 구현해야함.
                //showAlert(msg: "카카오톡 미설치 디바이스")
                
            }
        }
        
    }
}
