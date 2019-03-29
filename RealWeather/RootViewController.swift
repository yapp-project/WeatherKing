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
    @IBOutlet fileprivate weak var drawerViewLeading: NSLayoutConstraint!
    @IBOutlet fileprivate weak var drawerViewWidth: NSLayoutConstraint!
    
    fileprivate var drawerViewController: DrawerViewController!
    fileprivate var homeNavigationController: UINavigationController!
    fileprivate var homeNavigationBarViewController: HomeNavigationBarViewController!
    
    var drawerWidth: CGFloat {
        let drawerRatio: CGFloat = drawerViewWidth.constant
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        return screenWidth * drawerRatio
    }
    
    var isDrawerOpen: Bool = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home" {
            homeNavigationController = segue.destination as? UINavigationController
        } else if segue.identifier == "Drawer" {
            drawerViewController = segue.destination as? DrawerViewController
        } else if segue.identifier == "HomeNavigationBar" {
            homeNavigationBarViewController = segue.destination as? HomeNavigationBarViewController
        }
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

