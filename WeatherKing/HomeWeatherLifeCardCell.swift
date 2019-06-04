//
//  HomeWeatherLifeCardCell.swift
//  WeatherKing
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class HomeWeatherLifeCardCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var clotheLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var backView: UIView!
}

extension HomeWeatherLifeCardCell: HomeWeatherCardCell {
    func updateView(card: RWHomeCard?) {
        guard let lifeCard = card as? RWHomeLifeCard else {
            return
        }
        
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
        cardView.backgroundColor = lifeCard.mainColor
        titleLabel.text = lifeCard.title
        imageView.image = lifeCard.image
        clotheLabel.text = lifeCard.tempDegree?.clotheDescription
        
        backView.isHidden = true
        backView.alpha = 0.0
    }
}
