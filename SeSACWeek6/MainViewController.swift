//
//  MainViewController.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/09.
//

import UIKit

import Kingfisher
/*
 
 awakeFromNib - 셀 UI 초기화, 재사용 메커니즘에 의해 일정 횟수 이상 호출되지 않음.
 
 cellForItemAt
 - 재사용될 때 마다, 사용자에게 보일 때 마다 항상 실행됨.
 - 화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음.
 
 prepareForReuse
 - 셀이 재사용 될 때 초기화 하고자 하는 값을 넣으면 오류를 해결할 수 있음. 즉
    cellForRowAt에서 모든 indexPath.item에 대한 조건을 작성하지 않아도 됨!
 
 CollectionView in TableView
 - 하나의 컬렉션뷰나 테이블뷰라면 문제 X
 - 복합적인 구조라면, 테이블뷰도 재사용이 되어야 하고, 컬렉션셀도 재사용이 되어야 함.
 - Index -> reloadData
 
 */

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    let color: [UIColor] = [.brown, .cyan, .lightGray, .yellow, .blue]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](1...10),
        [Int](1000...1010),
        [Int](1...110),
        [Int](100...110),
        [Int](1...10),
        [Int](55...59),
        [Int](10000...10010),
        [Int](10000...10010),
        [Int](10000...10010)
    ]
    
    var episodeList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil)
            , forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true
        
        TMDBAPIManager.shared.requestImage { value in
            dump(value)
            // 1. 네트워크 통신 2. 배열 생성 3. 배열 담기 4. 뷰 등에 표현
            self.episodeList = value
            self.mainTableView.reloadData()
        }

    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 내부 매개변수 tableView를 통해 테이블뷰를 특정
    // 테이블뷰 객체가 하나일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
//        print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.contentCollecctionView.backgroundColor = .black
        cell.contentCollecctionView.delegate = self
        cell.contentCollecctionView.dataSource = self
        cell.contentCollecctionView.tag = indexPath.section
        cell.contentCollecctionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil)
            , forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        cell.titleLabel.text = TMDBAPIManager.shared.tvList[indexPath.section].0
        cell.contentCollecctionView.reloadData() // Index Out of Range
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    // 내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀이 재사용되면 특정 collectionViewCell을 재사용하게 될 수 있음.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
//        print("MainViewController", #function, indexPath)
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            cell.cardView.posterImageView.backgroundColor = collectionView.tag.isMultiple(of: 2) ? .brown : .cyan
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.posterImageView.kf.setImage(with: url)
            cell.cardView.titleLabel.text = ""
//            cell.cardView.titleLabel.text = "\(numberList[collectionView.tag][indexPath.row])"
            
//            if indexPath.item < 2 {
//                cell.cardView.titleLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
//            }
//            else {
//                cell.cardView.titleLabel.text = "HAPPY"
//            }
        }
        
//        cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}
