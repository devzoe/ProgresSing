//
//  Lyrics.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/14.
//

import Foundation
public enum StartLyricsTime: String {
    case time1 = "00:05"
}
public enum EndLyricsTime: String {
    case time1 = "00:07"
}

struct Lyrics {
    var koreanLyrics : [String]
    var englishLyrics : [String]
    
    init() {
        self.koreanLyrics = [
            "찢어진 종잇조각에",
            "담아낸 나의 진심에",
            "선명해져 somethin' bout you",
            "나를 많이 닮은 듯 다른",
            "넌 혹시 나와 같을까 지금",
            "괜한 기대를 해",
            "하루 한 달 일 년쯤 되면",
            "서로 다른 일상을 살아가",
            "나는 아니야",
            "쉽지 않을 것 같아",
            "여전하게도 넌 내 하루하루를 채우고",
            "아직은 아니야",
            "바보처럼 되뇌는 나",
            "입가에 맴도는 말을 삼킬 수 없어",
            "It's not fine",
            "It's not fine",
            "머릴 질끈 묶은 채",
            "어지러운 방을 정리해",
            "찾고 있어 something new",
            "가끔 이렇게 감당할 수 없는",
            "뭐라도 해야 할 것만 같은 기분에",
            "괜히 움직이곤 해",
            "하루 한 달 일 년 그쯤이면",
            "웃으며 추억할 거라 했지만",
            "나는 아니야",
            "쉽지 않을 것 같아",
            "여전하게도 넌 내 하루하루를 채우고",
            "아직은 아니야",
            "바보처럼 되뇌는 나",
            "입가에 맴도는 말을 삼킬 수 없어",
            "It's not fine",
            "(It's not fine)",
            "It's not fine",
            "의미 없는 농담 주고받는 대화",
            "사람들 틈에 난 아무렇지 않아 보여",
            "무딘 척 웃음을 지어 보이며",
            "너란 그늘을 애써 외면해보지만",
            "우리 마지막",
            "그 순간이 자꾸 떠올라",
            "잘 지내란 말이 전부였던 담담한 이별",
            "아직은 아니야",
            "바보처럼 되뇌는 그 말",
            "입가에 맴도는 말을 삼킬 수 없어",
            "It's not fine",
            "It's not fine",
            "It's not fine"
        ]
        self.englishLyrics = []    }
}