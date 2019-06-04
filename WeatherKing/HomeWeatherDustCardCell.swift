//
//  HomeWeatherDustCardCell.swift
//  WeatherKing
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
}

extension HomeWeatherDustCardCell: HomeWeatherCardCell {
    func updateView(card: RWHomeCard?) {
        guard let dustCard = card as? RWHomeDustCard else {
            return
        }
        
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
        cardView.backgroundColor = dustCard.type.color
        titleLabel.text = dustCard.type.title
        imageView.image = dustCard.type.image
        
        let fineDustDegree: Int = dustCard.fineDustDegree
        let ultraDustDegree: Int = dustCard.ultraDustDegree
        
        fineDustDegreeLabel.text = "\(fineDustDegree)"
        ultraDustDegreeLabel.text = "\(ultraDustDegree)"
        fineDustStatusLabel.text = RWHomeDustType.fineDustDescription(fineDust: fineDustDegree)
        ultraDustStatusLabel.text = RWHomeDustType.ultraDustDescription(ultraDust: ultraDustDegree)
        
        pm10DegreeLabel.text = "\(dustCard.fineDustDegree)"
        pm25DegreeLabel.text = "\(dustCard.ultraDustDegree)"
        o3DegreeLabel.text = "\(dustCard.o3Degree)"
        no2DegreeLabel.text = "\(dustCard.no2Degree)"
        coDegreeLabel.text = "\(dustCard.coDegree)"
        so2DegreeLabel.text = "\(dustCard.so2Degree)"
        providedTimeLabel.text = dustCard.providedTime
        
        backView.isHidden = true
        backView.alpha = 0.0
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
