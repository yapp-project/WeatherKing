//
//  HomeWeatherCardCollectionCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeWeatherCardCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var cards: [WeatherCard] = [] {
        didSet {
            collectionView?.register(cellTypes: [.weatherCard])
            collectionView?.reloadData()
        }
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType: HomeCellType = .weatherCard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
        
        if let cardCell = cell as? HomeWeatherCardCell {
            cardCell.updateView(card: cards[indexPath.item])
        }
        
        return cell
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeWeatherCardCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomeCellType.weatherCard.size
    }
}
