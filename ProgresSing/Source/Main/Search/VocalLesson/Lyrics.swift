//
//  Lyrics.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/14.
//

import Foundation
/*
public enum StartLyricsTime1: String {
    case time1 = "00:05"
    case time2 = "00:11"
    case time3 = "00:20"
    case time4 = "00:27"
    case time5 = "00:38"
    case time6 = "00:44"
    case time7 = "00:52"
    case time8 = "01:00"
}
public enum EndLyricsTime1: String {
    case time1 = "00:07"
    case time2 = "00:15"
    case time3 = "00:22"
    case time4 = "00:33"
    case time5 = "00:40"
    case time6 = "00:49"
    case time7 = "00:54"
    case time8 = "01:10"
}
public enum StartLyricsTime2: String {
    case time1 = "00:09"
    case time2 = "00:16"
    case time3 = "00:22"
    case time4 = "00:33"
    case time5 = "00:41"
    case time6 = "00:49"
    case time7 = "00:55"
    case time8 = "01:10"
}
public enum EndLyricsTime2: String {
    case time1 = "00:11"
    case time2 = "00:19"
    case time3 = "00:26"
    case time4 = "00:38"
    case time5 = "00:43"
    case time6 = "00:51"
    case time7 = "00:59"
    case time8 = "01:12"
}
 */

struct Lyrics {
    var koreanLyrics : [String]
    var englishLyrics : [String]
    var startLyricsTime1 : [String]
    var endLyricsTime1 : [String]
    var startLyricsTime2 : [String]
    var endLyricsTime2 : [String]
    
    var vocalFryTime : [Float]
    var beltTime : [Float]
    var vibratoTime : [Float]

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
            //"(It's not fine)",
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
        self.englishLyrics = []
        
        self.startLyricsTime1 = [
            "00:06",
            "00:11",
            "00:20",
            "00:27",
            "00:38",
            "00:44",
            "00:52",
            "01:00",
            "01:12",
            "01:17",
            "01:25",
            "01:34",
            "01:45",
            "01:50",
            "01:58",
            "02:06",
            "02:18",
            "02:29",
            "02:40",
            "02:45",
            "02:53",
            "03:01",
            "03:23"
        ]
        self.endLyricsTime1 = [
            "00:07",
            "00:15",
            "00:22",
            "00:33",
            "00:40",
            "00:49",
            "00:54",
            "01:10",
            "01:14",
            "01:22",
            "01:28",
            "01:39",
            "01:46",
            "01:55",
            "02:00",
            "02:16",
            "02:23",
            "02:34",
            "02:41",
            "02:50",
            "02:56",
            "03:12",
            "03:25"
        ]
        
        self.startLyricsTime2 = [
            "00:08",
            "00:17",
            "00:23",
            "00:33",
            "00:41",
            "00:49",
            "00:55",
            "01:10",
            "01:14",
            "01:23",
            "01:29",
            "01:39",
            "01:47",
            "01:55",
            "02:01",
            "02:16",
            "02:23",
            "02:34",
            "02:42",
            "02:51",
            "02:56",
            "03:12"
        ]
        self.endLyricsTime2 = [
            "00:11",
            "00:19",
            "00:26",
            "00:38",
            "00:43",
            "00:51",
            "00:59",
            "01:12",
            "01:17",
            "01:25",
            "01:33",
            "01:44",
            "01:49",
            "01:58",
            "02:05",
            "02:18",
            "02:29",
            "02:40",
            "02:44",
            "02:52",
            "03:01",
            "03:23"
        ]
        self.vocalFryTime = [
            6,9,14,17,18,20,28,29,31,
            
            75,80,86,90,96,96.5,97,
            100,
            141
            
        ]
        self.beltTime = [
            39,
            50,
            53,
            103,
            105,
            108,
            116,
            119,
            161,163,171,174
            
        ]
        self.vibratoTime = [
            26,
            33,
            37,
            48,
            59,
            81,
            94,
            99,
            114,
            125,
            147,149,154
        ]
    }
}
