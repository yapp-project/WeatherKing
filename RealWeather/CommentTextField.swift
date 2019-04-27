//
//  commentTextField.swift
//  Test
//
//  Created by 박진수 on 30/03/2019.
//  Copyright © 2019 박진수. All rights reserved.
//

import UIKit

protocol CommentTextFieldDelegate {
    func registerComment()
}

class CommentTextField: UITextField, UITextFieldDelegate {
    
    var commentDelegate: CommentTextFieldDelegate?
    var registerButton: UIButton!
    
    override func awakeFromNib() {
        initView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    private func initView() {
        let button = UIButton(type: .custom)
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15)
        button.setTitleColor(UIColor.mainColor, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: self.frame.height)
        button.addTarget(self, action: #selector(registerComment(_:)), for: .touchUpInside)
        
        registerButton = UIButton(type: .custom)
        registerButton.setTitle("등록", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15)
        registerButton.setTitleColor(UIColor.mainColor, for: .normal)
        registerButton.frame = CGRect(x: 0, y: 0, width: 50, height: self.frame.height)
        registerButton.addTarget(self, action: #selector(registerComment(_:)), for: .touchUpInside)
        
        self.rightView = button
        self.rightView = registerButton
        self.rightViewMode = .always
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: self.frame.height))
        self.translatesAutoresizingMaskIntoConstraints  = false
        self.leftView = leftPadding
        self.leftViewMode = ViewMode.always
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.bgColor.cgColor
        self.layer.cornerRadius = 12
        self.borderStyle = .none
        
        self.delegate = self
    }
    
    @objc func registerComment(_ sender: UIButton) {
        commentDelegate?.registerComment()
        self.text = ""
        self.endEditing(true)
    }
    
}
