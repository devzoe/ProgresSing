//
//  VocalLessonRequest.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/03/14.
//

import Foundation
struct VocalLessonRequest: Encodable {
    var data: [Float]
    var label : String
    var idx : Int
}
