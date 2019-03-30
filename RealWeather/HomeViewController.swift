//
//  HomeViewController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

public enum HomeCellType {
    case weatherCardCollection
    case weatherTempCard
    case weatherStatusCard
    case weatherDustCard
    case weatherCompareCard
    case weatherMenu
    case bestCommentCollection
    case bestComment
    
    var identifier: String {
        switch self {
        case .weatherCardCollection:
            return "HomeWeatherCardCollectionCell"
        case .weatherTempCard:
            return "HomeWeatherTempCardCell"
        case .weatherStatusCard:
            return "HomeWeatherStatusCardCell"
        case .weatherDustCard:
            return "HomeWeatherDustCardCell"
        case .weatherCompareCard:
            return "HomeWeatherCompareCardCell"
        case .weatherMenu:
            return "HomeWeatherMenuCell"
        case .bestCommentCollection:
            return "HomeBestCommentCollectionCell"
        case .bestComment:
            return "HomeBestCommentCell"
        }
    }
    
    var size: CGSize {
        switch self {
        case .weatherCardCollection:
            return CGSize(width: UIScreen.main.bounds.width, height: 420)
        case .weatherTempCard, .weatherStatusCard, .weatherDustCard, .weatherCompareCard:
            return CGSize(width: UIScreen.main.bounds.width, height: 390)
        case .weatherMenu:
            return CGSize(width: 24, height: 17)
        case .bestCommentCollection, .bestComment:
            return CGSize(width: UIScreen.main.bounds.width, height: 90)
        }
    }
}

class HomeViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var backgroundColorView: UIView!
    @IBOutlet fileprivate weak var commentContainer: UIView!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentBtn: UIButton!
    fileprivate let homeDataController: HomeDataController = HomeDataController()
    fileprivate let homeCellDatasource: [HomeCellType] = [.bestCommentCollection, .weatherCardCollection]
    fileprivate var commentViewController: HomeCommentViewController!
    fileprivate var notification: NotificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
        prepareCells()
        updateView()
    }
    
    fileprivate func prepareCells() {
        collectionView.register(cellTypes: homeCellDatasource)
    }
    
    fileprivate func prepareObservers() {
        
    }
}

extension HomeViewController {
    func updateView() {
        commentView.layer.applySketchShadow(color: UIColor.shadowColor30, alpha: 0.3, x: 0, y: -2, blur: 9, spread: 0)
//        commentView.layer.cornerRadius = 20
     
        commentBtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeComment" {
            commentViewController = segue.destination as? HomeCommentViewController
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType: HomeCellType = homeCellDatasource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
        
        if let weatherCollectionCell = cell as? HomeWeatherCardCollectionCell {
            let dummyCard: WeatherTempCard = WeatherTempCard()
            dummyCard.currentTemp = 30
            dummyCard.description = "어제보다 포근해요"
            dummyCard.estimatedTemp = 33
            dummyCard.minTemp = 29
            dummyCard.maxTemp = 33
            
            let dummyCard2: WeatherStatusCard = WeatherStatusCard()
            dummyCard2.title = "추적추적 추적비"
            dummyCard2.description = "강수량 220mm"
            dummyCard2.type = .rain
            
            let dummyCard3: WeatherDustCard = WeatherDustCard()
            dummyCard3.type = .worse
            
            weatherCollectionCell.cardDatasource.updateValue([dummyCard, dummyCard2, dummyCard3], forKey: .today)
            weatherCollectionCell.selectedMenu = .today
        } else if let bestCommentCollectionCell = cell as? HomeBestCommentCollectionCell {
            var dummyComment1: Comment = Comment()
            
            bestCommentCollectionCell.comments = [dummyComment1, dummyComment1]
//            bestCommentCollectionCell.comments = comments
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCellDatasource.count
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeCellDatasource[indexPath.item].size
    }
    
    func collectionView(_ collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension UICollectionView {
    // Home 이외에서도 사용될 경우 CellType으로 통합
    func register(cellTypes: [HomeCellType]) {
        cellTypes.forEach {
            let nib: UINib = UINib(nibName: $0.identifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: $0.identifier)
        }
    }
}
