//
//  ViewController.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function, "START")
        requestBlog(query: "아이유")
        print(#function, "END")
    }
    
    // Alamofire+SwiftyJSON
    // 검색 키워드
    // 인증키
    func requestBlog(query: String) {
        print(#function)
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.blog.requestURL + query
        let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.KAKAO)"]
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

