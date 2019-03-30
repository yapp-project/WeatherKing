//
//  HomeWeatherCompareCardCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 31/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeWeatherCompareCardCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var estimatedTempLabel: UILabel!
    @IBOutlet fileprivate weak var minMaxTempLabel: UILabel!
    
    func updateView(card: WeatherCompareCard?) {
//        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
//        cardView.backgroundColor = card?.mainColor
//        titleLabel.text = "지금은 " + (card?.currentTemp.tempFormat ?? "")
//        imageView.image = card?.image
//        descriptionLabel.text = card?.description
//        estimatedTempLabel.text = "체감온도 " + (card?.estimatedTemp.tempFormat ?? "")
//        minMaxTempLabel.text = (card?.minTemp.tempFormat ?? "") + " / " + (card?.maxTemp.tempFormat ?? "")
    }
}
