//
//  NickNameViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

enum NickNameStatus {
    case waitingForInput
    case available
    case currentlyInUse
    case irregularCharacter
    
    var infoText: String {
        switch self {
        case .waitingForInput:
            return ""
        case .available:
            return "사용할 수 있는 닉네임입니다."
        case .currentlyInUse:
            return "이미 사용중인 닉네임입니다."
        case .irregularCharacter:
            return "닉네임은 한글, 영문, 숫자만 사용할 수 있습니다."
        }
    }
}

class NickNameViewController: UIViewController {
    @IBOutlet private weak var nickNameField: UITextField!
    @IBOutlet private weak var nickNameInfoLabel: UILabel!
    @IBOutlet private weak var nickNameCountLabel: UILabel!
    @IBOutlet private weak var nickNameConfirmButton: UIButton!
    @IBOutlet private weak var nickNameClearButtonView: UIView!
    
    static let segueIdentifier: String = "NickName"
    private let maxNickNameCount: Int = 8
    private var nickNameStatus: NickNameStatus = .waitingForInput {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
}

extension NickNameViewController {
    private func updateView() {
        updateButton()
        updateNameCountLabel()
        updateInfoLabel()
    }
    
    private func updateNameCountLabel() {
        let nameCount: Int = nickNameField.text?.count ?? 0
        nickNameCountLabel.text = "\(nameCount)" + "/" + "\(maxNickNameCount)"
        nickNameClearButtonView.isHidden = nameCount < 1
    }
    
    private func updateInfoLabel() {
        nickNameInfoLabel.text = nickNameStatus.infoText
    }
    
    private func updateButton() {
        switch nickNameStatus {
        case .waitingForInput, .currentlyInUse, .irregularCharacter:
            nickNameConfirmButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8862745098, blue: 0.9019607843, alpha: 1)
            nickNameConfirmButton.isUserInteractionEnabled = false
        case .available:
            nickNameConfirmButton.backgroundColor = #colorLiteral(red: 0.3058823529, green: 0.3607843137, blue: 0.937254902, alpha: 1)
            nickNameConfirmButton.isUserInteractionEnabled = true
        }
    }
}

extension NickNameViewController {
    @IBAction func onConfirmNickNameBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: NotificationViewController.segueIdentifier, sender: nil)
    }
    
    @IBAction func onNicknameClearBtnTapped(_ sender: UIButton) {
        nickNameField.text?.removeAll()
        nickNameStatus = .waitingForInput
    }
    
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBackroundViewTapped(_ sender: Any) {
        nickNameField.resignFirstResponder()
    }
    
    @IBAction func onNickNameFieldChanged(_ sender: UITextField) {
        guard let text = sender.text, text.isEmpty == false else {
            nickNameStatus = .waitingForInput
            return
        }
        
        if let currentText = sender.text {
            let length: Int = (currentText as NSString).length
            let range: NSRange = NSRange(location: 0, length: length)
            let regex: NSRegularExpression? = try? NSRegularExpression(pattern: "^[ㄱ-ㅎㅏ-ㅣ가-힣0-9a-zA-Z//s]{0,10}$", options: .caseInsensitive)
            let result = regex?.matches(in: currentText, options: .anchored, range: range).map {
                (currentText as NSString).substring(with: $0.range)
            }
            
            let isIrrgular: Bool = !currentText.isEmpty && (result?.isEmpty ?? true)
            if isIrrgular {
                nickNameStatus = .irregularCharacter
            } else {
                // TODO: 서버 연결 후 이미 사용중인 닉네임 분기
                nickNameStatus = .available
            }
        }
        updateView()
    }
}

extension NickNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString = (textField.text as NSString?) ?? ""
        let expectedText = currentText.replacingCharacters(in: range, with: string)
        let textCount = expectedText.count
        
        if textCount <= maxNickNameCount {
            return true
        } else {
            return false
        }
    }
}
