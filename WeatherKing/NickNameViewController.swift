//
//  NickNameViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

enum NickNameStatus {
    case waitingForInput
    case waitingForServerCheck
    case available
    case currentlyInUse
    case irregularCharacter
    
    var infoText: String {
        switch self {
        case .waitingForInput:
            return ""
        case .waitingForServerCheck:
            return "중복 닉네임 체크 중입니다."
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
    private let dataController = NickNameDataController()
    private let maxNickNameCount: Int = 8
    private var nickNameStatus: NickNameStatus = .waitingForInput {
        didSet {
            updateView()
        }
    }
    
    var user: RWUser?
    
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
        case .waitingForInput, .currentlyInUse, .irregularCharacter, .waitingForServerCheck:
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
        guard let user = user, let nickname = nickNameField.text else {
            return
        }
        
        user.nickname = nickname
        user.location = RWLocationManager.shared.currentLocation
        
        RootViewController.shared().startLoading()
        RWLoginManager.shared.register(user: user) { [weak self] result in
            if result {
                self?.performSegue(withIdentifier: NotificationViewController.segueIdentifier, sender: nil)
            }
            RootViewController.shared().stopLoading()
        }
        self.performSegue(withIdentifier: NotificationViewController.segueIdentifier, sender: nil)
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
                dataController.checkIfNicknameExists(currentText) { [weak self] result in
                    guard let result = result, result else {
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

class NickNameDataController {
    private let requestor: RWApiRequest = RWApiRequest()
    
    func checkIfNicknameExists(_ nickname: String, completion: @escaping (Bool?) -> Void) {
        let queries: [URLQueryItem] = [URLQueryItem(name: "nickname", value: nickname)]
        
        requestor.cancel()
        requestor.method = .get
        requestor.baseURLPath = AppCommon.baseURL + "/main/nickname"
        requestor.fetch(with: queries) { [weak self] data, error in
            let completionInMainThread = { (completion: @escaping (Bool?) -> Void, result: Bool?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let result: Bool? = try self?.parseCheckResult(data)
                completionInMainThread(completion, result)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
    
    func requestNicknameChange(_ nickname: String, completion: @escaping (RWUser?) -> Void) {
        guard let user = RWLoginManager.shared.user else {
            completion(nil)
            return
        }
        
        let jsonBody: [String: Any] = [
            "type": user.loginMethod.rawValue,
            "uid": user.uniqueID,
            "newName": "\(nickname)"
        ]
        
        requestor.cancel()
        requestor.method = .put
        requestor.baseURLPath = AppCommon.baseURL + "/setting/user"
        requestor.fetch(with: jsonBody) { [weak self] data, error in
            let completionInMainThread = { (completion: @escaping (RWUser?) -> Void, result: RWUser?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let userInfo: RWUser? = try self?.parseUserInfo(data)
                completionInMainThread(completion, userInfo)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
    
    private func parseCheckResult(_ data: Data?) throws -> Bool? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        return jsons["status"] as? Bool
    }
    
    private func parseUserInfo(_ data: Data?) throws -> RWUser? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        
        let region = RWRegion()
        if let regionData = jsons["region"] as? [String: Any] {
            region.cityName = (regionData["cityName"] as? String) ?? ""
            region.sidoName = (regionData["sidoName"] as? String) ?? ""
            region.townName = (regionData["townName"] as? String) ?? ""
            region.pos = (regionData["pos"] as? String) ?? ""
        }
        
        var user: RWUser?
        if let loginType = jsons["type"] as? String, let loginMethod = SignUpMethod(rawValue: Int(loginType) ?? 5) {
            let userID: String = (jsons["userid"] as? String) ?? ""
            user = RWUser(userID: userID, loginMethod: loginMethod)
            user?._id = (jsons["_id"] as? String) ?? ""
            user?.salt = (jsons["salt"] as? String) ?? ""
            user?.uniqueID = (jsons["uid"] as? String) ?? ""
            user?.nickname = (jsons["nickname"] as? String) ?? ""
            user?.location.latitude = (jsons["lat"] as? Double) ?? 0.0
            user?.location.longitude = (jsons["lng"] as? Double) ?? 0.0
            user?.region = region
            user?.__v = (jsons["__v"] as? Int) ?? 0
        }
        return user
    }
}
