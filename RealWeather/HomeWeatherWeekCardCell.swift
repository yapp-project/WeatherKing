//
//  HomeWeatherWeekCardCell.swift
//  RealWeather
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeWeatherWeekCardCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var cardView: UIView!
    
    private var weekInfos: [RWHomeWeekInfo] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib: UINib = UINib(nibName: "HomeWeatherWeekCardBackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeWeatherWeekCardBackCell")
    }
    
    func updateView(card: RWHomeWeekCard?) {
        weekInfos = card?.weekInfos ?? []
        tableView.reloadData()
        
        cardView.layer.applySketchShadow(color: .cardShadowColor, alpha: 1, x: 0, y: 5, blur: 8, spread: 0)
    }
}

extension HomeWeatherWeekCardCell: WeatherCardCell {
    func flipCard() {
    }
}

extension HomeWeatherWeekCardCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWeatherWeekCardBackCell", for: indexPath)
        
        if let backCell = cell as? HomeWeatherWeekCardBackCell {
            backCell.updateView(data: weekInfos[indexPath.item])
        }
        
        return cell
    }
}

class HomeWeatherWeekCardBackCell: UITableViewCell {
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var weatherImageView: UIImageView!
    @IBOutlet fileprivate weak var tempLabel: UILabel!
    
    func updateView(data: RWHomeWeekInfo) {
        timeLabel.text = (Date.dateAfter(days: data.daysAfter)?.dayOfWeek ?? "") + "은"
        weatherImageView.image = data.image
        tempLabel.text = data.minTemp.tempFormat + " / " + data.maxTemp.tempFormat
        descriptionLabel.text = data.pmStatus
    }
}

extension Date {
    static func dateAfter(days: Int) -> Date? {
        let today: Date = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = days
        
        return calendar.date(byAdding: dateComponents, to: today)
    }
    
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

