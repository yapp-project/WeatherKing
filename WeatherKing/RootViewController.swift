//
//  RootViewController.swift
//  WeatherKing
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    
    class func shared() -> RootViewController {
        guard let RootVC = UIApplication.shared.delegate?.window??.rootViewController as? RootViewController else {
            return RootViewController()
        }
        return RootVC
    }
    
    @IBOutlet private weak var splashView: UIView!
    @IBOutlet private weak var drawerViewTrailing: NSLayoutConstraint!
    @IBOutlet private weak var drawerViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var loadingController: RWLoadingController!
    @IBOutlet private weak var drawerBackgroundView: UIView!
    @IBOutlet private weak var drawerContrainerView: UIView!
    
    fileprivate var drawerViewController: DrawerViewController!
    fileprivate var homeNavigationController: UINavigationController!
    fileprivate var prevTouchLocationX: CGFloat = .zero
    var homeNavigationBarViewController: HomeNavigationBarViewController!
    
    fileprivate let notification: NotificationCenter = NotificationCenter.default
    
    var drawerWidth: CGFloat {
        return drawerViewWidth.constant
    }
    
    var isDrawerOpen: Bool = false
    var navigationView: UIView {
        return homeNavigationBarViewController.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
        setDrawerWidth()
    }
    
    private func prepareObservers() {
        notification.addObserver(self, selector: #selector(updateView), name: .LoginSuccess, object: nil)
    }
    
    private func setDrawerWidth() {
        let drawerRatio: CGFloat = 0.8
        let screenWidth: CGFloat = view.frame.width
        drawerViewWidth.constant = screenWidth * drawerRatio
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

// MARK: Alert
extension RootViewController {
    func presentNetworkErrorAlert() {
        let alert = UIAlertController(title: "네트워크 오류", message: "네트워크 연결 상태를 확인해주세요", preferredStyle: .alert)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            window.resignKey()
            window.isHidden = true
            window.removeFromSuperview()
            window.windowLevel = .alert - 1
            window.setNeedsLayout()
        }
        alert.addAction(okAction)
        window.windowLevel = .alert + 1
        window.makeKeyAndVisible()
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension RootViewController {
    func openDrawer(completion: (() -> Void)? = nil) {
        view.bringSubviewToFront(drawerBackgroundView)
        view.bringSubviewToFront(drawerContrainerView)
        
        let animations: () -> Void = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.drawerViewTrailing.constant = self.drawerWidth
            self.drawerBackgroundView.alpha = 0.7
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: animations) { [weak self] _ in
            self?.isDrawerOpen = true
            completion?()
        }
    }
    
    func closeDrawer(completion: (() -> Void)? = nil) {
        let animations: () -> Void = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.drawerViewTrailing.constant = 0
            self.drawerBackgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: animations) { [weak self] _ in
            guard let `self` = self else {
                completion?()
                return
            }
            
            self.isDrawerOpen = false
            self.view.sendSubviewToBack(self.drawerBackgroundView)
            self.view.sendSubviewToBack(self.drawerContrainerView)
            completion?()
        }
    }
    
    @IBAction func onDrawerBackgroundTapped(_ sender: UIButton) {
        closeDrawer()
    }
    
    @IBAction func onDrawerTapped(_ sender: UIGestureRecognizer) {
        let touchLocationX: CGFloat = sender.location(in: view).x
        switch sender.state {
        case .began:
            prevTouchLocationX = touchLocationX
        case .changed:
            if isDrawerOpen {
                let scrollAmount: CGFloat = prevTouchLocationX - touchLocationX
                drawerViewTrailing.constant = min(drawerWidth, max(0, drawerViewTrailing.constant - scrollAmount))
                prevTouchLocationX = touchLocationX
            }
        case .ended:
            if isDrawerOpen {
                if touchLocationX > drawerWidth - 10 {
                    openDrawer()
                } else {
                    closeDrawer()
                }
            }
        default:
            break
        }
    }
}

extension RootViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return drawerContrainerView.frame.contains(touch.location(in: view))
    }
}
