//
//  RankingRequest.swift
//  UpSing
//
//  Created by 남경민 on 2023/03/30.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Ranking: Codable {
    //@DocumentID var documentID: String?
    //@ServerTimestamp var serverTS: Timestamp?
    let nickname: String
    let score: Float

    
    init(nickname: String, score: Float) {
        self.nickname = nickname
        self.score = score
    }
    private enum CodingKeys: String, CodingKey {
        case nickname
        case score
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nickname = try values.decode(String.self, forKey: .nickname)
        score = try values.decode(Float.self, forKey: .score)
    }
}
