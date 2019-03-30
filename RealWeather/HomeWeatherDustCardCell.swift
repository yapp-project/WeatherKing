//
//  HomeWeatherDustCardCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeWeatherDustCardCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var estimatedTempLabel: UILabel!
    @IBOutlet fileprivate weak var minMaxTempLabel: UILabel!
    
    var dustDatas: [WeatherDustData] = []
    
    func updateView(card: WeatherDustCard?) {
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
        cardView.backgroundColor = card?.mainColor
        titleLabel.text = "지금은 " + (card?.currentTemp.tempFormat ?? "")
        imageView.image = card?.image
        descriptionLabel.text = card?.description
        estimatedTempLabel.text = "체감온도 " + (card?.estimatedTemp.tempFormat ?? "")
        minMaxTempLabel.text = (card?.minTemp.tempFormat ?? "") + " / " + (card?.maxTemp.tempFormat ?? "")
    }
}

// TODO: 추후 연결 - 시연은 더미데이터로 대체
extension HomeWeatherDustCardCell: UICollectionViewDelegate {
    
}

extension HomeWeatherDustCardCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dustDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension HomeWeatherDustCardCell: UICollectionViewDelegateFlowLayout {
    
}

class HomeWeatherDustCardBackCell: UICollectionViewCell {
    
}
