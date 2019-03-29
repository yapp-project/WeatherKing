//
//  HomeNavigationBarViewController.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeNavigationBarViewController: UIViewController {
    
    @IBAction func onOpenDrawerBtnTapped(_ sender: UIButton) {
        (parent as? RootViewController)?.openDrawer()
    }
}
