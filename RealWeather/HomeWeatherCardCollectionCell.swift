//
//  HomeWeatherCardCollectionCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

public enum HomeWeatherMenu: CaseIterable {
    case today
    case tomorrow
    case week
    
    var title: String {
        switch self {
        case .today:
            return "오늘"
        case .tomorrow:
            return "내일"
        case .week:
            return "주간"
        }
    }
}

class HomeWeatherCardCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var menuCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var cardCollectionView: UICollectionView!
    
    var menuDatasource: [HomeWeatherMenu] = HomeWeatherMenu.allCases
    var cardDatasource: [HomeWeatherMenu: [WeatherCard]] = [:]
    var selectedMenu: HomeWeatherMenu = .today {
        didSet {
            menuCollectionView?.reloadData()
            cards = cardDatasource[selectedMenu] ?? []
        }
    }
    
    var cards: [WeatherCard] = [] {
        didSet {
            cardCollectionView?.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuCollectionView?.register(cellTypes: [.weatherMenu])
        cardCollectionView?.register(cellTypes: [.weatherCard])
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            return menuDatasource.count
        } else {
            return cards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            let cellType: HomeCellType = .weatherMenu
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let menuCell = cell as? HomeWeatherMenuCell {
                let title: String = menuDatasource[indexPath.item].title
                let isSelected: Bool = menuDatasource[indexPath.item] == selectedMenu
                menuCell.updateView(isSelected: isSelected, title: title)
            }
            
            return cell
        } else {
            let cellType: HomeCellType = .weatherCard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let cardCell = cell as? HomeWeatherCardCell {
                cardCell.updateView(card: cards[indexPath.item])
            }
            
            return cell
        }
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView {
            selectedMenu = menuDatasource[indexPath.item]
        } else {
            
        }
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView {
            return HomeCellType.weatherMenu.size
        } else {
            return HomeCellType.weatherCard.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == menuCollectionView {
            return UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == menuCollectionView {
            return 36
        } else {
            return 0
        }
    }
}
