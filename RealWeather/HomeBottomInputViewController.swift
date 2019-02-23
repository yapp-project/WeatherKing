//
//  HomeBottomInputViewController.swift
//  RealWeather
//
//  Created by sdondon on 24/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeBottomInputViewController: UIViewController {
    @IBOutlet fileprivate weak var profileView: UIView!
    @IBOutlet fileprivate weak var commentTextField: UITextField!
    
    @objc func dismissKeyboard() {
        commentTextField?.resignFirstResponder()
    }
    
    @IBAction func onRegisterCommentBtnTapped(_ sender: UIButton) {
        guard let commentText = commentTextField.text else {
            return
        }
        
        (parent as? HomeViewController)?.registerComment(commentText)
        (parent as? HomeViewController)?.isKeyboardToggled = false
        dismissKeyboard()
    }
}

extension HomeBottomInputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (parent as? HomeViewController)?.isKeyboardToggled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (parent as? HomeViewController)?.isKeyboardToggled = false
    }
}
