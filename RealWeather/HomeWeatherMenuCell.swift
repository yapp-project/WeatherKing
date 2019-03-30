//
//  HomeWeatherMenuCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeWeatherMenuCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    func updateView(isSelected: Bool, title: String) {
        if isSelected {
            titleLabel.textColor = .charcoalGrey
        } else {
            titleLabel.textColor = .lightBlueGrey
        }
        titleLabel?.text = title
    }
}
