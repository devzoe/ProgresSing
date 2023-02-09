//
//  Search.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/10.
//

import Foundation

struct Search {
    var imageName : String
    var rank : String
    var title : String
    var artist : String
}
struct SearchService {
    var searchList : [Search] = []
    // count
    var count: Int { self.searchList.count }
    
    init() {
        [
            Search(imageName: "Ditto", rank: "1", title: "Ditto", artist: "NewJeans"),
            Search(imageName: "Ditto", rank: "2", title: "OMG", artist: "NewJeans"),
            
        ].forEach { search in
            self.searchList.append(search)
        }
    }
    // Read
    public func read(at: Int) -> Search {
        return searchList[at]
    }
}
