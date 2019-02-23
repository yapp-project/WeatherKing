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
    @IBOutlet fileprivate weak var inputContainer: UIView!
    @IBOutlet fileprivate weak var inputContainerHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tapGestureRecognizableView: UIView!
    
    fileprivate var bottomInputViewController: HomeBottomInputViewController!
    fileprivate var commentViewController: HomeCommentViewController!
    fileprivate var topViewController: HomeTopViewController!
    fileprivate var notification: NotificationCenter = NotificationCenter.default
    fileprivate var keyboardHeight: CGFloat = 0
    
    var isKeyboardToggled: Bool = false {
        didSet {
            updateBottomInputView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
        prepareKeyboardResign()
        updateBottomInputView()
    }
    
    fileprivate func prepareObservers() {
        notification.addObserver(self, selector: #selector(updateKeyboardHeight(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    fileprivate func prepareKeyboardResign() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizableView?.addGestureRecognizer(recognizer)
    }
}

extension HomeViewController {
    @objc fileprivate func updateKeyboardHeight(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
        }
    }
    
    @objc func dismissKeyboard() {
        bottomInputViewController.dismissKeyboard()
    }
}

extension HomeViewController {
    func updateBottomInputView() {
        if isKeyboardToggled {
            tapGestureRecognizableView.isHidden = false
            view.bringSubviewToFront(tapGestureRecognizableView)
            inputContainerHeight.constant = keyboardHeight + 60
        } else {
            tapGestureRecognizableView.isHidden = true
            view.sendSubviewToBack(tapGestureRecognizableView)
            inputContainerHeight.constant = 60
        }
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeTop" {
            topViewController = segue.destination as? HomeTopViewController
        } else if segue.identifier == "HomeComment" {
            commentViewController = segue.destination as? HomeCommentViewController
        } else if segue.identifier == "HomeBottomInput" {
            bottomInputViewController = segue.destination as? HomeBottomInputViewController
        }
    }
}
