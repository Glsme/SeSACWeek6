//
//  URL+Extention.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/08.
//

import Foundation

extension URL {
    static let kakaoBaseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointString(_ endPoint: String) -> String {
        return kakaoBaseURL + endPoint
    }
}
