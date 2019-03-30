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
    
    @IBAction func onOpenDrawerBtnTapped(_ sender: UIButton) {
        (parent as? RootViewController)?.openDrawer()
    }
    
    @IBAction func onOpenLocationBtnTapped(_ sender: UIButton) {
        // present location setting view (modal)
    }
}
