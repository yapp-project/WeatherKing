//
//  NotificationViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

enum NotificationSetting: Int {
    case everyday
    case rain
    case finedust
}

class NotificationViewController: UIViewController {
    @IBOutlet private weak var fineDustNotiCheckView: NotificationCheckView!
    @IBOutlet private weak var everydayNotiCheckView: NotificationCheckView!
    @IBOutlet private weak var rainNotiCheckView: NotificationCheckView!
    @IBOutlet private weak var confirmButtonView: UIButton!
    
    static let segueIdentifier: String = "Notification"
    
    private var selectedSettings: [NotificationSetting] = [.everyday, .rain, .finedust]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateConfirmButtonView()
    }
    
    private func updateConfirmButtonView() {
        if selectedSettings.isEmpty {
            confirmButtonView.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8862745098, blue: 0.9019607843, alpha: 1)
            confirmButtonView.isUserInteractionEnabled = false
        } else {
            confirmButtonView.backgroundColor = #colorLiteral(red: 0.3058823529, green: 0.3607843137, blue: 0.937254902, alpha: 1)
            confirmButtonView.isUserInteractionEnabled = true
        }
    }
}
    
extension NotificationViewController {
    @IBAction func onCheckBoxTapped(_ sender: UIButton) {
        guard let selectedSetting = NotificationSetting(rawValue: sender.tag) else {
            return
        }
        
        switch selectedSetting {
        case .everyday:
            everydayNotiCheckView.isSelected = !everydayNotiCheckView.isSelected
        case .rain:
            rainNotiCheckView.isSelected = !rainNotiCheckView.isSelected
        case .finedust:
            fineDustNotiCheckView.isSelected = !fineDustNotiCheckView.isSelected
        }
        
        if let indexToRemove = selectedSettings.firstIndex(of: selectedSetting) {
            selectedSettings.remove(at: indexToRemove)
        } else {
            selectedSettings.append(selectedSetting)
        }
        updateConfirmButtonView()
    }
    
    @IBAction func onConfirmBtnTapped(_ sender: UIButton) {
        let isEverydayNotiEnabled: Bool = selectedSettings.contains(.everyday)
        let isRainNotiEnabled: Bool = selectedSettings.contains(.rain)
        let isFineDustNotiEnabled: Bool = selectedSettings.contains(.finedust)
        
        UserDefaultsManager.EverydayNotificationSetting.set(isEverydayNotiEnabled)
        UserDefaultsManager.RainNotificationSetting.set(isRainNotiEnabled)
        UserDefaultsManager.FineDustNotificationSetting.set(isFineDustNotiEnabled)
        
        (presentingViewController as? RootViewController)?.removeSplashView()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCheckLaterBtnTapped(_ sender: UIButton) {
        (presentingViewController as? RootViewController)?.removeSplashView()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

class NotificationCheckView: UIView {
    @IBOutlet private weak var checkImageView: UIImageView!
    
    var isSelected: Bool = true {
        didSet {
            checkImageView.image = isSelected ? #imageLiteral(resourceName: "checkBox1") : #imageLiteral(resourceName: "checkBox")
        }
    }
}
