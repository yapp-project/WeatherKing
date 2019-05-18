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
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var message: UILabel!
    var isInput = false
    @IBOutlet weak var okBtn: UIBarButtonItem!
    
    var currentNickName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.isEnabled = false
        okBtn.tintColor = UIColor(red: 173, green: 181, blue: 189, a: 1)
        nickField.text = "프로출근러"
        currentNickName = "프로출근러"

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.BarAction))
        toolbar.items = [doneBtn]
        nickField.inputAccessoryView = toolbar
        
    }
    
    @IBAction func TextfieldEditingChanged(_ sender: UITextField) {
        if let count = sender.text?.count {
            textCount.text = "\(count) / 8"
        } else {
            print("nil")
        }
        if sender.text != nickField.text {
            checkString(newText: sender.text ?? "", isInput: false)
        } else {
            if sender.text == "" {
                checkString(newText: sender.text ?? "", isInput: false)
            } else {
                checkString(newText: sender.text ?? "", isInput: true)
            }
        }
        
    }
    @objc func BarAction() {
        view.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkString(newText:String, isInput: Bool) -> Void {
        let filter:String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]"
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in:newText, options: [], range:NSRange.init(location: 0, length:newText.count))
        if isInput == true {
            if(list.count != newText.count){
                message.text = "닉네임은 한글, 영문, 숫자만 사용할 수 있습니다."
                okBtn.isEnabled = false
                okBtn.tintColor = UIColor(red: 173, green: 181, blue: 189, a: 1)
                return
            }
            
            message.text = "사용할 수 있는 닉네임입니다."
            okBtn.isEnabled = true
            okBtn.tintColor = UIColor(red: 78, green: 92, blue: 239, a: 1)
            print("ok")
            return
        } else {
            message.text = "닉네임을 입력해주세요."
            okBtn.isEnabled = false
            okBtn.tintColor = UIColor(red: 173, green: 181, blue: 189, a: 1)
            print("ok 2")
            return
        }
    }
}

extension SettingNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("string : \(string)")
        
//        let inputText: String = textField.text ?? ""
//        if currentNickName != inputText {
//            isInput = true
//        } else {
//            isInput = false
//        }
//        currentNickName = inputText
        
        if string == "" {
            isInput = false
        } else {
            isInput = true
        }
        guard let text = nickField.text else { return false }
        print("text : \(text)")
        let newLength = text.characters.count + string.characters.count - range.length
        
        return newLength <= 8
    }
    
}
