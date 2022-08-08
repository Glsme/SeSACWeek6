//
//  ViewController.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/08.
//

import UIKit

import SwiftyJSON

/*
 1. html tag <> </> 기능 활용
 2. 문자열 대체 메서드 사용
 */

/*
 TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게
 - 조건: 레이블 numberOfLines 0
 - 조건: tableView height automationDimention
 - 조건: 레이아웃
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false // fase 2줄, true 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 모든 섹션의 셀에 대하여 유동적, 메서드 우선!
        
        searchBlog()
    }
    
    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "아이유") { json in
//            print(json)
            
            for item in json["documents"].arrayValue {
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b", with: "")
                self.blogList.append(value)
            }
            
            self.searchCafe()
        }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            print(json)
            
            for item in json["documents"].arrayValue {
                self.cafeList.append(item["contents"].stringValue)
            }
            
            print(self.blogList)
            print(self.cafeList)
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func expandButtonClicked(_ sender: UIBarButtonItem) {
        isExpanded = !isExpanded
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kakaoCell", for: indexPath) as? kakaoCell else { return UITableViewCell() }
        
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class kakaoCell: UITableViewCell {
    @IBOutlet weak var testLabel: UILabel!
}
