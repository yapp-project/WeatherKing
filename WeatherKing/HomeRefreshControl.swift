//
//  HomeRefreshControl.swift
//  WeatherKing
//
//  Created by USER on 01/06/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class HomeRefreshControl: UIControl {
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var isRefreshing: Bool = false
    var threshold: CGFloat = -50
    
    func startRefreshing() {
        isRefreshing = true
        loadingIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.sendActions(for: .valueChanged)
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.loadingIndicator.alpha = 1.0
            }
        }
    }
    
    func stopRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isRefreshing = false
            self?.loadingIndicator.stopAnimating()
            
            UIView.animate(withDuration: 0.2) {
                self?.scrollView.contentInset.top = 0
                self?.loadingIndicator.alpha = 0.0
                self?.superview?.layoutIfNeeded()
            }
        }
    }
    
    func scrollRefeshControl(_ scrollView: UIScrollView) {
        let scrollOffsetY = scrollView.contentOffset.y
        
        guard scrollOffsetY < 15 else {
            return
        }
        
        if isRefreshing {
            UIView.animate(withDuration: 0.1) {
                scrollView.contentInset.top = 50
            }
        } else {
            scrollView.contentInset.top = 0
        }
        
        if scrollView.isDragging == false && scrollOffsetY < threshold {
            if isRefreshing == false {
                startRefreshing()
            }
        }
    }
}
