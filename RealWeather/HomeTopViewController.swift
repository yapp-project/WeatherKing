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
    @IBOutlet fileprivate weak var lineView: UIView!
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate let dataController = HomeTopDataController()
    
    var timeWeatherDatasource: [HomeTopTimeWeatherData] = []
    var todayWeather: [TodayWeather] = []
    
    var viewsToTransform: [UIView] {
        return [headerView, smallTitleView, bigTitleView, lineView]
    }
    
    var homeTopData: HomeTopData? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        dataController.requestData { [weak self] data in
            if let weather = data {
                self?.todayWeather = weather.todayWeather
                self?.bigTempLabel.text = weather.temperature
                self?.bigDescLabel.text = weather.comment
                self?.collectionView.reloadData()
            }
        }
    }
    
    func updateView() {
        collectionView.reloadData()
    }
    
}

extension HomeTopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todayWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTopTimeWeatherCell", for: indexPath)
        
        if let weatherCell = cell as? HomeTopTimeWeatherCell {
            weatherCell.fill(weather: self.todayWeather[indexPath.item])
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40.0
    }
}

class HomeTopTimeWeatherCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    func fill(weather: TodayWeather) {
        timeLabel.text = weather.time
        tempLabel.text = String(weather.temp) + "˚"
    }
    
}
