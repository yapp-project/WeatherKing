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
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    
    var bgControlDelegate: HomeBGColorControlDelegate?
    var menuDatasource: [HomeWeatherMenu] = HomeWeatherMenu.allCases
    var cardDatasource: [HomeWeatherMenu: [RWHomeCard]] = [:]
    var selectedMenu: HomeWeatherMenu = .today {
        didSet {
            menuCollectionView?.reloadData()
            cards = cardDatasource[selectedMenu] ?? []
        }
    }
    
    var cards: [RWHomeCard] = [] {
        didSet {
            pageControl.numberOfPages = cards.count
            pageControl.currentPage = 0
            cardCollectionView?.reloadData()
            cardCollectionView?.setContentOffset(.zero, animated: true)
            updateThemeColor(with: cards.first)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuCollectionView?.register(cellTypes: [.weatherMenu])
        cardCollectionView?.register(cellTypes: [.weatherTempCard, .weatherDustCard, .weatherStatusCard, .weatherLifeCard, .weatherWeekCard])
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
        
        // TODO: 한 타입으로 묶어서 정리 필요
        if collectionView == menuCollectionView {
            let cellType: HomeCellType = .weatherMenu
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let menuCell = cell as? HomeWeatherMenuCell {
                let title: String = menuDatasource[indexPath.item].title
                let isSelected: Bool = menuDatasource[indexPath.item] == selectedMenu
                menuCell.updateView(isSelected: isSelected, title: title)
            }
            return cell
            
        } else if let tempCard = cards[indexPath.item] as? RWHomeTempCard {
            let cellType: HomeCellType = .weatherTempCard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let cardCell = cell as? HomeWeatherTempCardCell {
                cardCell.updateView(card: tempCard)
            }
            return cell
            
        } else if let statusCard = cards[indexPath.item] as? RWHomeStatusCard {
            let cellType: HomeCellType = .weatherStatusCard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let cardCell = cell as? HomeWeatherStatusCardCell {
                cardCell.updateView(card: statusCard)
            }
            return cell
            
        } else if let dustCard = cards[indexPath.item] as? RWHomeDustCard {
            let cellType: HomeCellType = .weatherDustCard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let cardCell = cell as? HomeWeatherDustCardCell {
                cardCell.updateView(card: dustCard)
            }
            return cell
        } else if let lifeCard = cards[indexPath.item] as? RWHomeLifeCard {
            let cellType: HomeCellType = .weatherLifeCard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let cardCell = cell as? HomeWeatherLifeCardCell {
                cardCell.updateView(card: lifeCard)
            }
            return cell
        } else if let weekCard = cards[indexPath.item] as? RWHomeWeekCard {
            let cellType: HomeCellType = .weatherWeekCard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
            
            if let cardCell = cell as? HomeWeatherWeekCardCell {
                cardCell.updateView(card: weekCard)
            }
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.weatherTempCard.identifier, for: indexPath)
        }
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == menuCollectionView {
            selectedMenu = menuDatasource[indexPath.item]
            // TODO: protocol로 flipcard 하나로 묶을 것
        } else if let cardCell = collectionView.cellForItem(at: indexPath) as? WeatherCardCell {
            cardCell.flipCard()
        }
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView {
            return HomeCellType.weatherMenu.size
        } else {
            return HomeCellType.weatherTempCard.size
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

extension HomeWeatherCardCollectionCell: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        let targetPage: Int
        if translation.x > 0 {
            targetPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        } else {
            targetPage = Int(scrollView.contentOffset.x / scrollView.bounds.width) + 1
        }
        
        if cards.indices.contains(targetPage) {
            updateThemeColor(with: cards[targetPage])
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
        
        if cards.indices.contains(page) {
            updateThemeColor(with: cards[page])
        }
    }
}

extension HomeWeatherCardCollectionCell {
    func updateThemeColor(with card: RWHomeCard?) {
        guard let card = card else {
            return
        }
        
        bgControlDelegate?.updateThemeColor(card.mainColor)
        pageControl.currentPageIndicatorTintColor = card.mainColor
    }
}
