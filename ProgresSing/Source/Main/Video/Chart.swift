//
//  Chart.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/10.
//

import Foundation

struct Chart {
    var imageName : String
    var rank : String
    var title : String
    var artist : String
}
struct ChartService {
    var chartList : [Chart] = []
    // count
    var count: Int { self.chartList.count }
    
    init() {
        [
            Chart(imageName: "Ditto", rank: "1", title: "Ditto", artist: "NewJeans"),
            Chart(imageName: "Ditto", rank: "2", title: "OMG", artist: "NewJeans"),
            Chart(imageName: "HypeBoy", rank: "3", title: "Hype boy", artist: "NewJeans"),
            Chart(imageName: "VIBE", rank: "4", title: "VIBE (feat. Jimin of BTS)", artist: "태양"),
            Chart(imageName: "사건의지평선", rank: "5", title: "사건의 지평선", artist: "윤하 (YOUNHA)"),
            Chart(imageName: "부석순", rank: "6", title: "파이팅 해야지 (Feat. 이영지)", artist: "부석순 (SEVENTEEN)"),
            Chart(imageName: "투바투", rank: "7", title: "Sugar Rush Ride", artist: "투모로우바이투게더"),
            Chart(imageName: "르세라핌", rank: "8", title: "ANTIFRAGILE", artist: "LE SSERAFIM (르세라핌)"),
            Chart(imageName: "HypeBoy", rank: "9", title: "Attention", artist: "NewJeans"),
            Chart(imageName: "임영웅1", rank: "10", title: "사랑은 늘 도망가", artist: "임영웅"),
            Chart(imageName: "아이브", rank: "11", title: "After LIKE", artist: "IVE (아이브)"),
            Chart(imageName: "nct", rank: "12", title: "Candy", artist: "NCT DREAM"),
            Chart(imageName: "부석순", rank: "13", title: "7시에 들어줘 (Feat. Peder Elias)", artist: "부석순 (SEVENTEEN)"),
            Chart(imageName: "임영웅2", rank: "14", title: "우리들의 블루스", artist: "임영웅"),
            Chart(imageName: "부석순", rank: "15", title: "LUNCH", artist: "부석순 (SEVENTEEN)"),
            Chart(imageName: "임영웅2", rank: "16", title: "다시 만날 수 있을까", artist: "임영웅"),
        ].forEach { chart in
            self.chartList.append(chart)
        }
    }
    // Read
    public func read(at: Int) -> Chart {
        return chartList[at]
    }
}
