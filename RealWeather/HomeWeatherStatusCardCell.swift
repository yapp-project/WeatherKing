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
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var rainAndSnowDegreeLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var backView: UIView!
    
    @IBOutlet fileprivate weak var humidityLabel: UILabel!
    @IBOutlet fileprivate weak var windVelocityLabel: UILabel!
    @IBOutlet fileprivate weak var rainProbabilityLabel: UILabel!
    
    func updateView(card: RWHomeStatusCard?) {
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
        cardView.backgroundColor = card?.mainColor
        titleLabel.text = card?.type.description
        imageView.image = card?.type.image
        statusLabel.text = card?.type.rawValue
        
        backView.isHidden = true
        backView.alpha = 0.0
        
        let targetTimeData = card?.timeTempDatas.filter { $0.time == .am12 }.first
        guard let timeData = targetTimeData else {
            rainAndSnowDegreeLabel.isHidden = true
            return
        }
        
        if timeData.rainfall > 0 {
            rainAndSnowDegreeLabel.isHidden = false
            rainAndSnowDegreeLabel.text = "강수량 \(timeData.rainfall)mm"
        } else if timeData.snowfall > 0 {
            rainAndSnowDegreeLabel.isHidden = false
            rainAndSnowDegreeLabel.text = "적설량 \(timeData.snowfall)cm"
        } else {
            rainAndSnowDegreeLabel.isHidden = true
        }
        
        humidityLabel.text = "\(timeData.humidity)"
        windVelocityLabel.text = "\(timeData.windVelocity)"
        rainProbabilityLabel.text = "\(timeData.rainPop)"
    }
}

extension HomeWeatherStatusCardCell: WeatherCardCell {
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
