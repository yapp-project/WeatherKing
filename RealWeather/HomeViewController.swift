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
        case .weatherTempCard, .weatherStatusCard, .weatherDustCard:
            return CGSize(width: UIScreen.main.bounds.width, height: 390)
        case .weatherMenu:
            return CGSize(width: 24, height: 17)
        case .bestCommentCollection, .bestComment:
            return CGSize(width: UIScreen.main.bounds.width, height: 90)
        }
    }
}

protocol WeatherCardCell: class {
    func flipCard()
}

protocol HomeBGColorControlDelegate {
    func updateThemeColor(_ color: UIColor)
}

class HomeViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var backgroundColorView: UIView!
    @IBOutlet fileprivate weak var commentContainer: UIView!
    @IBOutlet fileprivate weak var commentBtn: UIButton!
    
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
        commentContainer.layer.applySketchShadow(color: UIColor.shadowColor30, alpha: 1, x: 0, y: -2, blur: 9, spread: 0)

    }
}

extension HomeViewController: HomeBGColorControlDelegate {
    func updateThemeColor(_ color: UIColor) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.backgroundColorView.backgroundColor = color
        }
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
            dummyCard.currentTemp = 5
            dummyCard.description = "어제보다 추워요"
            dummyCard.estimatedTemp = 4
            dummyCard.minTemp = 3
            dummyCard.maxTemp = 10
            
            let dummyCard2: WeatherStatusCard = WeatherStatusCard()
            dummyCard2.title = "가랑가랑 가랑비"
            dummyCard2.description = "딱 적당히 내리고 있어요"
            dummyCard2.estimatedDegree = "강수량 10mm"
            dummyCard2.type = .rain
            
            let dummyCard3: WeatherDustCard = WeatherDustCard()
            dummyCard3.type = .good
            
            let dummyCard4: WeatherTempCard = WeatherTempCard()
            dummyCard4.currentTemp = 8
            dummyCard4.description = "내일은 포근해요"
            dummyCard4.estimatedTemp = 10
            dummyCard4.minTemp = 3
            dummyCard4.maxTemp = 10
            
            let dummyCard5: WeatherStatusCard = WeatherStatusCard()
            dummyCard5.title = "정말 맑은 날씨"
            dummyCard5.description = "아주 화창해요"
            dummyCard5.type = .sunny
            
            let dummyCard6: WeatherDustCard = WeatherDustCard()
            dummyCard6.type = .notBad
            
            let dummyCardMon: WeatherStatusCard = WeatherStatusCard()
            dummyCardMon.title = "월요일은 구름 많음"
            dummyCardMon.description = "흐린 날씨에요"
            dummyCardMon.type = .cloudy
            
            let dummyCardTue: WeatherStatusCard = WeatherStatusCard()
            dummyCardTue.title = "화요일은 흐림"
            dummyCardTue.description = "우산 꼭 챙기세요"
            dummyCardTue.estimatedDegree = "강수량 10mm"
            dummyCardTue.type = .rain
            
            let dummyCardWed: WeatherStatusCard = WeatherStatusCard()
            dummyCardWed.title = "수요일은 대설"
            dummyCardWed.description = "소복소복 눈이와요"
            dummyCardWed.estimatedDegree = "적설량 220mm"
            dummyCardWed.type = .snow

            let dummyCardThu: WeatherStatusCard = WeatherStatusCard()
            dummyCardThu.title = "목요일은 천둥번개"
            dummyCardThu.description = "외출을 삼가세요"
            dummyCardThu.estimatedDegree = "강수량 300mm"
            dummyCardThu.type = .thunder
            
            let dummyCardFri: WeatherStatusCard = WeatherStatusCard()
            dummyCardFri.title = "금요일은 안개"
            dummyCardFri.description = "아침 운전에 조심하세요"
            dummyCardFri.estimatedDegree = ""
            dummyCardFri.type = .foggy

            let dummyCardSat: WeatherStatusCard = WeatherStatusCard()
            dummyCardSat.title = "토요일은 맑음"
            dummyCardSat.description = "피크닉가기 좋은 날씨에요"
            dummyCardSat.estimatedDegree = ""
            dummyCardSat.type = .sunny

            let dummyCardSun: WeatherStatusCard = WeatherStatusCard()
            dummyCardSun.title = "일요일은 약간 흐림"
            dummyCardSun.description = "야외활동에 무리없어요"
            dummyCardSun.estimatedDegree = ""
            dummyCardSun.type = .bitCloudy
            
            weatherCollectionCell.cardDatasource.updateValue([dummyCard, dummyCard2, dummyCard3], forKey: .today)
            weatherCollectionCell.cardDatasource.updateValue([dummyCard4, dummyCard5, dummyCard6], forKey: .tomorrow)
            weatherCollectionCell.cardDatasource.updateValue([dummyCardMon, dummyCardTue, dummyCardWed, dummyCardThu, dummyCardFri, dummyCardSat, dummyCardSun], forKey: .week)
            weatherCollectionCell.selectedMenu = .today
            weatherCollectionCell.bgControlDelegate = self
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
