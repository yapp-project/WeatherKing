//
//  HomeViewController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet fileprivate weak var commentContainer: UIView!
    @IBOutlet fileprivate weak var topContainer: UIView!
    @IBOutlet fileprivate weak var topContainerHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var inputContainer: UIView!
    @IBOutlet fileprivate weak var inputContainerHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tapGestureRecognizableView: UIView!
    @IBOutlet fileprivate weak var homeScrollView: UIScrollView!
    
    fileprivate let maxTopViewHeight: CGFloat = 462
    fileprivate let minTopViewHeight: CGFloat = 124
    fileprivate var bottomInputViewController: HomeBottomInputViewController!
    fileprivate var commentViewController: HomeCommentViewController!
    fileprivate var topViewController: HomeTopViewController!
    fileprivate var notification: NotificationCenter = NotificationCenter.default
    fileprivate var keyboardHeight: CGFloat = 0
    fileprivate var previousScrollOffset: CGPoint = .zero
    
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
        updateScrollView(commentViewController.scrollView)
    }
    
    fileprivate func prepareObservers() {
        notification.addObserver(self, selector: #selector(updateKeyboardHeight(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    fileprivate func prepareKeyboardResign() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizableView?.addGestureRecognizer(recognizer)
    }
    
    func registerComment(_ text: String) {
        commentViewController.registerComment(text)
    }
}

extension HomeViewController {
    @objc fileprivate func updateKeyboardHeight(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
        }
        isKeyboardToggled = true
    }
    
    @objc func dismissKeyboard() {
        bottomInputViewController.dismissKeyboard()
    }
}

extension HomeViewController {
    fileprivate func updateBottomInputView() {
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
    
    fileprivate func updateScrollView(_ scrollView: UIScrollView) {
        homeScrollView.addGestureRecognizer(scrollView.panGestureRecognizer)
    }
}

extension HomeViewController {
    func scrollTopView(_ scrollView: UIScrollView) {
        let scrollOffset: CGFloat = scrollView.contentOffset.y
        let scrollAmount: CGFloat = abs(scrollOffset - previousScrollOffset.y)
        let isNeutral: Bool = scrollOffset <= 0
        let isScrollUp: Bool = scrollOffset > previousScrollOffset.y
        let isScrollDown: Bool = scrollOffset < previousScrollOffset.y
        let isTopViewOpening: Bool = scrollOffset < maxTopViewHeight
        
        if isNeutral {
            let newHeight: CGFloat = maxTopViewHeight
            let translationOffset: CGFloat = scrollOffset
            let alpha: CGFloat = 1.0
            
            topContainerHeight.constant = newHeight
            topContainer.transform = CGAffineTransform(translationX: 0, y: -translationOffset)
            topContainer.alpha = alpha
            
        } else if isScrollUp {
            let newHeight: CGFloat = max(minTopViewHeight, min(maxTopViewHeight, topContainerHeight.constant - scrollAmount))
            let translationOffset: CGFloat = (maxTopViewHeight - newHeight) / 2
            let alpha: CGFloat = (newHeight - minTopViewHeight) / maxTopViewHeight
            
            topContainerHeight.constant = newHeight
            topViewController.viewsToTransform.forEach {
                $0.transform = CGAffineTransform(translationX: 0, y: -translationOffset)
                $0.alpha = alpha
            }
            topViewController.foldView.alpha = 1.0 - alpha
            
        } else if isScrollDown, isTopViewOpening {
            let newHeight: CGFloat = max(minTopViewHeight, min(maxTopViewHeight, topContainerHeight.constant + scrollAmount))
            let translationOffset: CGFloat = (maxTopViewHeight - newHeight) / 2
            let alpha: CGFloat = newHeight / maxTopViewHeight
            
            topContainerHeight.constant = newHeight
            topViewController.viewsToTransform.forEach {
                $0.transform = CGAffineTransform(translationX: 0, y: -translationOffset)
                $0.alpha = alpha
            }
            topViewController.foldView.alpha = 1.0 - alpha
        }
        previousScrollOffset = scrollView.contentOffset
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
