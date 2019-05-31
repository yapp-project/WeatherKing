//
//  RootViewController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    @IBOutlet fileprivate weak var splashView: UIView!
    @IBOutlet fileprivate weak var drawerViewLeading: NSLayoutConstraint!
    @IBOutlet fileprivate weak var drawerViewWidth: NSLayoutConstraint!
    @IBOutlet fileprivate weak var loadingController: RWLoadingController!
    
    class func shared() -> RootViewController {
        guard let RootVC = UIApplication.shared.delegate?.window??.rootViewController as? RootViewController else {
            return RootViewController()
        }
        return RootVC
    }
    
    fileprivate var drawerViewController: DrawerViewController!
    fileprivate var homeNavigationController: UINavigationController!
    var homeNavigationBarViewController: HomeNavigationBarViewController!
    
    fileprivate let notification: NotificationCenter = NotificationCenter.default
    
    var drawerWidth: CGFloat {
        let drawerRatio: CGFloat = drawerViewWidth.constant
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        return screenWidth * drawerRatio
    }
    
    var isDrawerOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
    }
    
    private func prepareObservers() {
        notification.addObserver(self, selector: #selector(updateView), name: .LoginSuccess, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home" {
            homeNavigationController = segue.destination as? UINavigationController
        } else if segue.identifier == "Drawer" {
            drawerViewController = segue.destination as? DrawerViewController
        } else if segue.identifier == "HomeNavigationBar" {
            homeNavigationBarViewController = segue.destination as? HomeNavigationBarViewController
        } else if segue.identifier == "Splash" {
            let splashVC = segue.destination as? SplashViewController
            
            splashVC?.loginSegueHandler = { [weak self] in
                self?.splashView.isHidden = true
            }
            splashVC?.completionHandler = { [weak self] in
                self?.removeSplashView()
            }
        }
    }
}

extension RootViewController {
    @objc func updateView() {
        homeNavigationBarViewController.updateView()
    }
    
    func removeSplashView() {
        splashView.removeFromSuperview()
    }
}

// MARK: Loading Controller
extension RootViewController {
    func startLoading() {
        loadingController?.startLoading()
    }
    
    func stopLoading() {
        loadingController?.stopLoading()
    }
}

extension RootViewController {
    func finishDraggingDrawer() {
        if isDrawerOpen {
            closeDrawer()
        } else {
            openDrawer()
        }
    }
    
    func moveDrawer(offset: CGFloat) {
        drawerViewLeading.constant = min(drawerWidth, max(0, drawerViewLeading.constant + offset))
    }
    
    func openDrawer() {
        drawerViewLeading.constant = drawerWidth
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.isDrawerOpen = true
        }
    }
    
    func closeDrawer() {
        drawerViewLeading.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.isDrawerOpen = false
        }
    }
}

