//
//  HomeWeatherTempCardCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeWeatherTempCardCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var estimatedTempLabel: UILabel!
    @IBOutlet fileprivate weak var minMaxTempLabel: UILabel!
    @IBOutlet fileprivate weak var backView: UIView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var timeTempDatas: [WeatherTempTimeData] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib: UINib = UINib(nibName: "HomeWeatherTempCardBackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeWeatherTempCardBackCell")
    }
    
    func updateView(card: WeatherTempCard?) {
        backView.isHidden = true
        backView.alpha = 0.0
        
        // MARK: 더미 데이터 삽입
        let dummyData1 = WeatherTempTimeData()
        dummyData1.timeTitle = "지금"
        dummyData1.weatherImage = UIImage(named: "icCloudCopy7")
        dummyData1.temperature = 10
        
        let dummyData2 = WeatherTempTimeData()
        dummyData2.timeTitle = "늦은밤"
        dummyData2.weatherImage = UIImage(named: "icCloudRain")
        dummyData2.temperature = 12
        
        let dummyData3 = WeatherTempTimeData()
        dummyData3.timeTitle = "한밤"
        dummyData3.weatherImage = UIImage(named: "icCloudRain")
        dummyData3.temperature = 12
        
        let dummyData4 = WeatherTempTimeData()
        dummyData4.timeTitle = "새벽"
        dummyData4.weatherImage = UIImage(named: "icCloudRain")
        dummyData4.temperature = 10
        
        let dummyData5 = WeatherTempTimeData()
        dummyData5.timeTitle = "아침"
        dummyData5.weatherImage = UIImage(named: "icCloudRain")
        dummyData5.temperature = 10
        
        let dummyData6 = WeatherTempTimeData()
        dummyData6.timeTitle = "늦은 오전"
        dummyData6.weatherImage = UIImage(named: "icCloudCopy7")
        dummyData6.temperature = 10
        
        timeTempDatas = [dummyData1, dummyData2, dummyData3, dummyData4, dummyData5, dummyData6]
        tableView.reloadData()
        
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
        cardView.backgroundColor = card?.mainColor
        titleLabel.text = "지금은 " + (card?.currentTemp.tempFormat ?? "")
        imageView.image = card?.type.image
        descriptionLabel.text = card?.description
        estimatedTempLabel.text = "체감온도 " + (card?.estimatedTemp.tempFormat ?? "")
        minMaxTempLabel.text = (card?.minTemp.tempFormat ?? "") + " / " + (card?.maxTemp.tempFormat ?? "")
    }
}

extension HomeWeatherTempCardCell: WeatherCardCell {
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

extension HomeWeatherTempCardCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTempDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWeatherTempCardBackCell", for: indexPath)
        
        if let backCell = cell as? HomeWeatherTempCardBackCell {
            backCell.updateView(data: timeTempDatas[indexPath.item])
        }
        
        return cell
    }
}

class HomeWeatherTempCardBackCell: UITableViewCell {
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var weatherImageView: UIImageView!
    @IBOutlet fileprivate weak var tempLabel: UILabel!
    
    func updateView(data: WeatherTempTimeData) {
        timeLabel.text = data.timeTitle
        weatherImageView.image = data.weatherImage
        tempLabel.text = data.temperature.tempFormat
    }
}

