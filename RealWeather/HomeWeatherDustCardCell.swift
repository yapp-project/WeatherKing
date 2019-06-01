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
    @IBOutlet fileprivate weak var backView: UIView!
    @IBOutlet fileprivate weak var fineDustStatusLabel: UILabel!
    @IBOutlet fileprivate weak var ultraDustStatusLabel: UILabel!
    @IBOutlet fileprivate weak var fineDustDegreeLabel: UILabel!
    @IBOutlet fileprivate weak var ultraDustDegreeLabel: UILabel!
    
    @IBOutlet fileprivate weak var pm10DegreeLabel: UILabel!
    @IBOutlet fileprivate weak var pm25DegreeLabel: UILabel!
    @IBOutlet fileprivate weak var o3DegreeLabel: UILabel!
    @IBOutlet fileprivate weak var no2DegreeLabel: UILabel!
    @IBOutlet fileprivate weak var coDegreeLabel: UILabel!
    @IBOutlet fileprivate weak var so2DegreeLabel: UILabel!
    @IBOutlet fileprivate weak var providedTimeLabel: UILabel!
    
    var dustDatas: [WeatherDustData] = []
    
    func updateView(card: RWHomeDustCard?) {
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
        cardView.backgroundColor = card?.type.color
        titleLabel.text = card?.type.title
        imageView.image = card?.type.image
        
        let fineDustDegree: Int = card?.fineDustDegree ?? 0
        let ultraDustDegree: Int = card?.ultraDustDegree ?? 0
        
        fineDustDegreeLabel.text = "\(fineDustDegree)"
        ultraDustDegreeLabel.text = "\(ultraDustDegree)"
        fineDustStatusLabel.text = RWHomeDustType.fineDustDescription(fineDust: fineDustDegree)
        ultraDustStatusLabel.text = RWHomeDustType.ultraDustDescription(ultraDust: ultraDustDegree)
        
        pm10DegreeLabel.text = "\(card?.fineDustDegree ?? 0)"
        pm25DegreeLabel.text = "\(card?.ultraDustDegree ?? 0)"
        o3DegreeLabel.text = "\(card?.o3Degree ?? 0.0)"
        no2DegreeLabel.text = "\(card?.no2Degree ?? 0.0)"
        coDegreeLabel.text = "\(card?.coDegree ?? 0.0)"
        so2DegreeLabel.text = "\(card?.so2Degree ?? 0)"
        
        providedTimeLabel.text = card?.providedTime
        
        backView.isHidden = true
        backView.alpha = 0.0
    }
}

extension HomeWeatherDustCardCell: WeatherCardCell {
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
