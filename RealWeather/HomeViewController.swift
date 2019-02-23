//
//  HomeViewController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet fileprivate weak var commentContainerHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var commentContainer: UIView!
    @IBOutlet fileprivate weak var topContainer: UIView!
    
    fileprivate var commentViewController: HomeCommentViewController!
    fileprivate var topViewController: HomeTopViewController!
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeTop" {
            topViewController = segue.destination as? HomeTopViewController
        } else if segue.identifier == "HomeComment" {
            commentViewController = segue.destination as? HomeCommentViewController
        }
    }
}
