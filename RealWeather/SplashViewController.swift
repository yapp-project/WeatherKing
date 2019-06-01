//
//  SplashViewController.swift
//  RealWeather
//
//  Created by SangDon Kim on 12/05/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    var loginSegueHandler: (() -> Void)?
    var completionHandler: (() -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if RWLoginManager.shared.isLoggedIn {
            completionHandler?()
        } else {
            performSegue(withIdentifier: "Login", sender: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.loginSegueHandler?()
            }
        }
    }
}
