//
//  SettingNicknameViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class SettingNicknameViewController: UIViewController {
    @IBOutlet weak var nickField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.BarAction))
        toolbar.items = [doneBtn]
        nickField.inputAccessoryView = toolbar
        
    }
    
    @objc func BarAction() {
        view.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = nickField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 8
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("aaaaaaaaaaaaaa")
    }
}
