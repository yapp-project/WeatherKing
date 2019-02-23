//
//  HomeTopViewController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeTopData {
    var temp: String = ""
}

class HomeTopTimeWeatherData {
    var temp: String = ""
}

class HomeTopViewController: UIViewController {
    @IBOutlet fileprivate weak var headerView: UIView!
    @IBOutlet fileprivate weak var headerLocationLabel: UILabel!
    @IBOutlet fileprivate weak var headerTimeLabel: UILabel!
    
    @IBOutlet fileprivate weak var bigTitleView: UIView!
    @IBOutlet fileprivate weak var bigTempLabel: UILabel!
    @IBOutlet fileprivate weak var bigDescLabel: UILabel!
    @IBOutlet fileprivate weak var bigNameLabel: UILabel!
    @IBOutlet fileprivate weak var bigLikeLabel: UILabel!
    
    @IBOutlet fileprivate weak var smallTitleView: UIView!
    @IBOutlet fileprivate weak var smallTempLabel: UILabel!
    @IBOutlet fileprivate weak var smallDescLabel: UILabel!
    @IBOutlet fileprivate weak var smallDustLabel: UILabel!
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var timeWeatherDatasource: [HomeTopTimeWeatherData] = []
    
    var homeTopData: HomeTopData? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
    }
}

extension HomeTopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeWeatherDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTopTimeWeatherCell", for: indexPath)
        
        if let weatherCell = cell as? HomeTopTimeWeatherCell {
//            let commentData: Comment = datasource[indexPath.item]
//            commentCell.updateUI(with: commentData)
        }
        
        return cell
    }
}

extension HomeTopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeTopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 28, height: 125)
    }
}

class HomeTopTimeWeatherCell: UICollectionViewCell {
    
}
