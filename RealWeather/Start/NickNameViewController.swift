//
//  NickNameViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class NickNameViewController: UIViewController {
    @IBOutlet private weak var nickField: UITextField!
    static let segueIdentifier: String = "NickName"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nickField.keyboardType = .default
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.AcrionBar))
        
        toolbar.items = [doneBtn]
        nickField.inputAccessoryView = toolbar
    }
    
    @objc func AcrionBar() {
        view.endEditing(true)
    }
    @IBAction func okBtn(_ sender: Any) {
        let stroyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = stroyboard.instantiateViewController(withIdentifier: "main")
        
        self.present(nextView,animated: true,completion: nil)
    }
}

extension NickNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = nickField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 8
    }
}
