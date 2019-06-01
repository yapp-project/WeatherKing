//
//  RWLoadingController.swift
//  RealWeather
//
//  Created by USER on 01/06/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class RWLoadingController: NSObject {
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func startLoading() {
        parentView.isUserInteractionEnabled = false
        parentView.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        loadingView.layer.zPosition = 1024
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.loadingView.alpha = 1.0
        }
    }
    
    func stopLoading() {
        parentView.isUserInteractionEnabled = true
        parentView.sendSubviewToBack(loadingView)
        loadingView.isHidden = true
        loadingView.layer.zPosition = 0
        activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.loadingView.alpha = 0.0
        }
    }
}
