//
//  SettingNicknameViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let UserNicknameDidChanged = Notification.Name("UserNicknameDidChanged")
}

class SettingNicknameViewController: UIViewController {
    @IBOutlet private weak var nickNameField: UITextField!
    @IBOutlet private weak var nickNameInfoLabel: UILabel!
    @IBOutlet private weak var nickNameCountLabel: UILabel!
    @IBOutlet private weak var nickNameConfirmButton: UIButton!
    @IBOutlet private weak var nickNameClearButtonView: UIView!
    
    static let segueIdentifier: String = "nickname"
    private let dataController = NickNameDataController()
    private let maxNickNameCount: Int = 8
    private var nickNameStatus: NickNameStatus = .waitingForInput {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextField()
        updateView()
    }
    
    private func prepareTextField() {
        setLeftPaddingForTextField()
        nickNameField.text = RWLoginManager.shared.user?.nickname ?? ""
    }
    
    private func setLeftPaddingForTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: nickNameField.frame.height))
        nickNameField.leftView = paddingView
        nickNameField.leftViewMode = .always
    }
}

extension SettingNicknameViewController {
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
        case .waitingForInput, .currentlyInUse, .irregularCharacter, .waitingForServerCheck, .serverError:
            nickNameConfirmButton.isEnabled = false
        case .available:
            nickNameConfirmButton.isEnabled = true
        }
    }
}

extension SettingNicknameViewController {
    @IBAction func onConfirmNickNameBtnTapped(_ sender: UIButton) {
        guard RWLoginManager.shared.user != nil, let nickname = nickNameField.text else {
            return
        }
        
        dataController.requestNicknameChange(nickname) { [weak self] result, error in
            guard let result = result, error == nil else {
                return
            }
            RWLoginManager.shared.user = result
            NotificationCenter.default.post(name: .UserNicknameDidChanged, object: nil)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onNicknameClearBtnTapped(_ sender: UIButton) {
        nickNameField.text?.removeAll()
        nickNameStatus = .waitingForInput
    }
    
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
                dataController.checkIfNicknameExists(currentText) { [weak self] result, error in
                    guard let result = result, error == nil else {
                        self?.nickNameStatus = .serverError
                        return
                    }
                    
                    guard result else {
                        self?.nickNameStatus = .currentlyInUse
                        return
                    }
                    self?.nickNameStatus = .available
                }
                //                nickNameStatus = .waitingForServerCheck
            }
        }
        updateView()
    }
}

extension SettingNicknameViewController: UITextFieldDelegate {
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
