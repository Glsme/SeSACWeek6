//
//  EndPoint.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/08.
//

import Foundation

enum EndPoint {
    case blog
    case cafe
    
    // 저장 프로퍼티를 못쓰는 이유: enum은 초기화 구문을 생성할 수 없어서 -> 연산 프로퍼티는 사용 가능
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
    
}
