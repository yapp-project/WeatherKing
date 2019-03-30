//
//  HomeWeatherStatusCardCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeWeatherStatusCardCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var estimatedTempLabel: UILabel!
    @IBOutlet fileprivate weak var minMaxTempLabel: UILabel!
    @IBOutlet fileprivate weak var backView: UIView!
    
    var statusDatas: [WeatherStatusData] = []
    
    func updateView(card: WeatherStatusCard?) {
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
        cardView.backgroundColor = card?.mainColor
        titleLabel.text = card?.title
        imageView.image = card?.type.image
        descriptionLabel.text = card?.description
    }
    
    func flipCard() {
        if backView.isHidden {
            self.backView.isHidden = false
            self.contentView.bringSubviewToFront(self.backView)
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.backView.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.backView.alpha = 0.0
            }) { _ in
                self.backView.isHidden = true
                self.contentView.sendSubviewToBack(self.backView)
            }
        }
    }
}

// TODO: 추후 연결
extension HomeWeatherStatusCardCell: UICollectionViewDelegate {
    
}

extension HomeWeatherStatusCardCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension HomeWeatherStatusCardCell: UICollectionViewDelegateFlowLayout {
    
}

class HomeWeatherStatusCardBackCell: UICollectionViewCell {
    
}
