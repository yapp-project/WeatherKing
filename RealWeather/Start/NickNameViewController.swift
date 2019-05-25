//
//  NickNameViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class NickNameViewController: UIViewController {
    @IBOutlet weak var nickField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nickField.keyboardType = .default
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "이 닉네임을 사용할래요", style: .done, target: self, action: #selector(self.AcrionBar))
        let spaceBtn = UIBarButtonItem(title: " ", style: .done, target: self, action: #selector(self.spaceBar))
        doneBtn.tintColor = UIColor(red: 182, green: 182, blue: 182)
        
        toolbar.items = [spaceBtn,doneBtn]
        nickField.inputAccessoryView = toolbar
    }
    
    @objc func AcrionBar() {
        let stroyboard:UIStoryboard = self.storyboard!
        let nextView = stroyboard.instantiateViewController(withIdentifier: "alertSetting")
        self.present(nextView,animated: true,completion: nil)
//        view.endEditing(true)
    }
    
    @objc func spaceBar() {
//        let stroyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextView = stroyboard.instantiateViewController(withIdentifier: "main")
//
//        self.present(nextView,animated: true,completion: nil)
                view.endEditing(true)
    }
    
    @IBAction func okBtn(_ sender: Any) {
        
    }
}

extension NickNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = nickField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 8
    }
}
