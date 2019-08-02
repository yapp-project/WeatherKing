//
//  SettingNotificationViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

enum NotificationSettingCellType: Int, CaseIterable {
    case allday //매일알림
    case morning    //아침시간
    case night  //저녁시간
    case rain   //비소식알림
    case dust   //미세먼지알림
    
    var identifier: String {
        switch self {
        case .allday, .rain, .dust:
            return "switchCell"
        case .morning, .night:
            return "buttonCell"
        }
    }
    
    var title: String {
        switch self {
        case .allday:
            return "매일 알림"
        case .morning:
            return "아침"
        case .night:
            return "저녁"
        case .rain:
            return "비소식 알림"
        case .dust:
            return "미세먼지 알림"
        }
    }
}

class SettingNotificationViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var menuDatasource: [NotificationSettingCellType] = NotificationSettingCellType.allCases
    private let morningDatePicker = UIDatePicker()
    private let nightDatePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    
    private var amNotificationTime: Double = 0 {
        didSet {
            let startOfDayInTime: Double = Date().startOfDay.timeIntervalSince1970
            let convertedTime: Double = amNotificationTime - startOfDayInTime
            UserDefaultsManager.EverydayAMNotificaitonTime.set(convertedTime)
        }
    }
    private var pmNotificationTime: Double = 0 {
        didSet {
            let startOfDayInTime: Double = Date().startOfDay.timeIntervalSince1970
            let convertedTime: Double = pmNotificationTime - startOfDayInTime
            UserDefaultsManager.EverydayPMNotificaitonTime.set(convertedTime)
        }
    }
    private var isEverydayNotiEnabled: Bool = false {
        didSet {
            UserDefaultsManager.EverydayNotificationSetting.set(isEverydayNotiEnabled)
        }
    }
    private var isRainNotiEnabled: Bool = false {
        didSet {
            UserDefaultsManager.RainNotificationSetting.set(isRainNotiEnabled)
        }
    }
    private var isFineDustNotiEnabled: Bool = false {
        didSet {
            UserDefaultsManager.FineDustNotificationSetting.set(isFineDustNotiEnabled)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        prepareDatePickers()
        loadSettings()
        updateMenu()
    }
}

extension SettingNotificationViewController {
    private func updateMenu() {
        if isEverydayNotiEnabled {
            menuDatasource = NotificationSettingCellType.allCases
        } else {
            menuDatasource = [.allday, .rain, .dust]
        }
        tableView.reloadData()
    }
    
    private func loadSettings() {
        amNotificationTime = UserDefaultsManager.EverydayAMNotificaitonTime.get() + Date().startOfDay.timeIntervalSince1970
        pmNotificationTime = UserDefaultsManager.EverydayPMNotificaitonTime.get() + Date().startOfDay.timeIntervalSince1970
        isEverydayNotiEnabled = UserDefaultsManager.EverydayNotificationSetting.get()
        isFineDustNotiEnabled = UserDefaultsManager.FineDustNotificationSetting.get()
        isRainNotiEnabled = UserDefaultsManager.RainNotificationSetting.get()
    }
    
    private func prepareDatePickers() {
        morningDatePicker.datePickerMode = .time
        morningDatePicker.minimumDate = Date().startOfDay
        morningDatePicker.maximumDate = Date().getSpecificTimeOfDay(hour: 11, minute: 59)
        morningDatePicker.timeZone = TimeZone(secondsFromGMT: 0)
        morningDatePicker.addTarget(self, action: #selector(self.morningPickerChange(_:)), for: .valueChanged)
        
        nightDatePicker.datePickerMode = .time
        nightDatePicker.minimumDate = Date().getSpecificTimeOfDay(hour: 12)
        nightDatePicker.maximumDate = Date().getSpecificTimeOfDay(hour: 23, minute: 59)
        nightDatePicker.timeZone = TimeZone(secondsFromGMT: 0)
        nightDatePicker.addTarget(self, action: #selector(self.nightPickerChange(_:)), for: .valueChanged)
        
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(onDatePickerDoneButtonTapped))
        toolbar.items = [doneBtn]
    }
    
}
extension SettingNotificationViewController {
    
    @objc private func onDatePickerDoneButtonTapped() {
        view.endEditing(true)
        tableView.reloadData()
    }
    
    @objc private func morningPickerChange(_ send: UIDatePicker) {
        amNotificationTime = send.date.timeIntervalSince1970
    }
    
    @objc func nightPickerChange(_ send: UIDatePicker) {
        pmNotificationTime = send.date.timeIntervalSince1970
    }
    
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSwitchToggled(_ sender: UISwitch) {
        guard let indexPath = sender.indexPath(), let cellType = NotificationSettingCellType(rawValue: indexPath.row) else {
            return
        }
        switch cellType {
        case .allday:
            isEverydayNotiEnabled = sender.isOn
        case .dust, .morning:
            isFineDustNotiEnabled = sender.isOn
        case .rain, .night:
            isRainNotiEnabled = sender.isOn
        }
        updateMenu()
    }
}

extension SettingNotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType: NotificationSettingCellType = menuDatasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)
        cell.saveIndexPath(indexPath: indexPath)
        
        if let switchCell = cell as? SettingNotificationSwitchCell {
            switch cellType {
            case .allday:
                switchCell.configureCell(title: cellType.title, isOn: isEverydayNotiEnabled)
            case .dust:
                switchCell.configureCell(title: cellType.title, isOn: isFineDustNotiEnabled)
            case .rain:
                switchCell.configureCell(title: cellType.title, isOn: isRainNotiEnabled)
            case .morning, .night:
                break
            }
        } else if let buttonCell = cell as? SettingNotificationButtonCell {
            if cellType == .morning {
                morningDatePicker.date = Date(timeIntervalSince1970: amNotificationTime)
                buttonCell.configureDatePicker(morningDatePicker, toolbar: toolbar)
                buttonCell.configureCell(cellType.title, timeText: amNotificationTime.simpleTimeTextFormat)
            } else {
                nightDatePicker.date = Date(timeIntervalSince1970: pmNotificationTime)
                buttonCell.configureDatePicker(nightDatePicker, toolbar: toolbar)
                buttonCell.configureCell(cellType.title, timeText: pmNotificationTime.simpleTimeTextFormat)
            }
        }
        return cell
    }
}

class SettingNotificationSwitchCell: UITableViewCell {
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var alertSwitch: UISwitch!

    override func saveIndexPath(indexPath: IndexPath) {
        super.saveIndexPath(indexPath: indexPath)
        alertSwitch.saveIndexPath(indexPath: indexPath)
    }
    
    func configureCell(title: String, isOn: Bool) {
        alertLabel.text = title
        alertSwitch.isOn = isOn
    }
}

class SettingNotificationButtonCell: UITableViewCell {
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var timeField: UITextField!
    
    func configureDatePicker(_ datePicker: UIDatePicker, toolbar: UIToolbar) {
        timeField.inputView = datePicker
        timeField.inputAccessoryView = toolbar
    }
    
    override func saveIndexPath(indexPath: IndexPath) {
        super.saveIndexPath(indexPath: indexPath)
        timeField.saveIndexPath(indexPath: indexPath)
    }
    
    func configureCell(_ title: String, timeText: String) {
        self.alertLabel.text = title
        self.timeField.text = timeText
    }
}
