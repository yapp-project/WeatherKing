//
//  HomeNavigationBarViewController.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeNavigationBarViewController: UIViewController {
    
    @IBOutlet fileprivate weak var locationLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    private var timer: Timer?
    
    var isCountingTime: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimerOnStart()
    }
    
    func updateView() {
        let cityName: String = RWLoginManager.shared.user?.region.cityName ?? ""
        let townName: String = RWLoginManager.shared.user?.region.townName ?? ""
        locationLabel.text = "\(cityName) \(townName)"
        updateTimeView()
    }
    
    private func updateTimeView() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = DateFormatter().amSymbol
        dateFormatter.pmSymbol = DateFormatter().pmSymbol
        dateFormatter.dateFormat = "HH:mm a"
        timeLabel.text = dateFormatter.string(from: currentDate)
    }
    
    private func startTimerOnStart() {
        let now = Date()
        let currentSeconds: Int = Calendar.current.component(.second, from: now)
        
        timer = Timer(fire: Date().addingTimeInterval(Double(60 - currentSeconds + 1)), interval: 60, repeats: true, block: { [weak self] _ in
            self?.updateTimeView()
        })
        
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .default)
        }
    }
    
    @IBAction func onOpenDrawerBtnTapped(_ sender: UIButton) {
        (parent as? RootViewController)?.openDrawer()
    }
    
    @IBAction func onOpenLocationBtnTapped(_ sender: UIButton) {
        // present location setting view (modal)
        
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "locationNavigation") {
            present(nextView, animated: true, completion: nil)
        }
    }
}
