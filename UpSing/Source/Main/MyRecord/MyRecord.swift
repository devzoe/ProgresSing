//
//  MyRecord.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/21.
//

import Foundation

/// 데이터를 추가 / 읽기 / 수정 / 삭제 (CRUD)
class MyRecordViewModel {
    // 싱글톤
    static let shared = MyRecordViewModel()
    private var recordList: [MyRecord] = []
    // count
    var count: Int { self.recordList.count }
    
    private init() {
        [
            
        ].forEach { record in
            self.recordList.append(record)
        }
    }
    // Create
    public func add(record : MyRecord) {
        self.recordList.append(record)
    }
    
    // Read
    public func read(at: Int) -> MyRecord {
        return recordList[at]
    }
    // Read
    public func readAll() -> [MyRecord] {
        return recordList
    }
    
}

struct MyRecord {
    let imageName: String
    let artist: String
    let title : String
    let recordURL : URL?
}
