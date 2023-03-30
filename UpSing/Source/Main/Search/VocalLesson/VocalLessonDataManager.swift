//
//  VocalLessonDataManager.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/03/14.
//

import Alamofire

class VocalLessonDataManager {
    func predict(parameters: VocalLessonRequest,delegate: VocalLessonViewController) {
        let url = "https://us-central1-elated-garden-379706.cloudfunctions.net/mlserver"
        
        
         AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
         .validate()
         .responseDecodable(of: VocalLessonResponse.self) { response in
         
         switch response.result {
         case .success(let response):
         // 성공했을 때
         
         delegate.didSuccessPredict(response)
         case .failure(let error):
         print(error.localizedDescription)
         delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
         }
         
         }
         
        /*
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil).response {
            response in
            switch response.result {
            case .success(let data):
                if let result = data {
                    if result == "True" {
                        print("true")
                        delegate.didSuccessPredict(true)
                    } else {
                        print("false")
                        delegate.didSuccessPredict(false)
                    }
                } else {
                    print("Failed to parse response")
                }
            case .failure(let error):
                print("Cloud Function call failed with error : \(error.localizedDescription)")
                delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
            }
        }
         */
    }
}
