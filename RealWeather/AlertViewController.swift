//
//  AlertViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

enum AlertSettingCellType: CaseIterable {
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

class AlertViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    let morningDatePicker = UIDatePicker()
    let nightDatePicker = UIDatePicker()
    let toolbar = UIToolbar()
    var morningTimeText: String? = "오전 7 : 00"
    var nightTimeText: String? = "오후 10 : 00"
    var menuDatasource: [AlertSettingCellType] = AlertSettingCellType.allCases
    var isAllday: Bool?
    
    func updateMenu() {
        if isAllday == true {
            menuDatasource = AlertSettingCellType.allCases
        } else {
            menuDatasource = [.allday, .rain, .dust]
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        morningDatePicker.datePickerMode = .time
        morningDatePicker.addTarget(self, action: #selector(self.morningPickerChange(_:)), for: .valueChanged)
        
        nightDatePicker.datePickerMode = .time
        nightDatePicker.addTarget(self, action: #selector(self.nightPickerChange(_:)), for: .valueChanged)
        
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.ActionBar))
        
        toolbar.items = [doneBtn]
        
    }
    @objc func ActionBar() {
        view.endEditing(true)
        tableView.reloadData()
    }
    @objc func morningPickerChange(_ send: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "a h:mm"
        let date = formatter.string(from: send.date)
        morningTimeText = date
    }
    
    @objc func nightPickerChange(_ send: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "a h:mm"
        let date = formatter.string(from: send.date)
        nightTimeText = date
    }
    @IBAction func setTime(_ sender: UIDatePicker) {
        guard let time = sender.indexPath() else {
            return
        }
    }
    
    @IBAction func backBtn(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSwitchToggled(_ sender: UISwitch) {
        guard let indexPath = sender.indexPath() else {
            return
        }
        if indexPath.row == 0 {
            isAllday = sender.isOn
            updateMenu()
        }
    }
}

extension AlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType: AlertSettingCellType = menuDatasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)
        cell.saveIndexPath(indexPath: indexPath)
        
        if let switchCell = cell as? AlertTableViewSwitchCell {
            
            if cellType == .allday {
                switchCell.updateView(title: cellType.title, isOn: isAllday)
            } else {
                switchCell.updateView(title: cellType.title, isOn: true)
            }
        } else if let buttonCell = cell as? AlertTableViewButtonCell {
            if cellType == .morning {
                buttonCell.timeField.inputView = morningDatePicker
                buttonCell.timeField.inputAccessoryView = toolbar
                buttonCell.updateView(title: cellType.title,time: morningTimeText ?? "")
            } else {
                buttonCell.timeField.inputView = nightDatePicker
                buttonCell.timeField.inputAccessoryView = toolbar
                buttonCell.updateView(title: cellType.title, time: nightTimeText ?? "")
            }
        }
        return cell
    }
}

class AlertTableViewSwitchCell: UITableViewCell {
    @IBOutlet fileprivate weak var alertLabel: UILabel!
    @IBOutlet fileprivate weak var alertSwitch: UISwitch!

    override func saveIndexPath(indexPath: IndexPath) {
        super.saveIndexPath(indexPath: indexPath)
        alertSwitch.saveIndexPath(indexPath: indexPath)
    }
    
    func updateView(title: String, isOn: Bool?) {
        self.alertLabel.text = title
        self.alertSwitch.isOn = isOn ?? true
    }
}

class AlertTableViewButtonCell: UITableViewCell {
    @IBOutlet fileprivate weak var alertLabel: UILabel!
    @IBOutlet weak var timeField: UITextField!
    
    override func saveIndexPath(indexPath: IndexPath) {
        super.saveIndexPath(indexPath: indexPath)
        timeField.saveIndexPath(indexPath: indexPath)
    }
    
    func updateView(title: String, time: String) {
        self.alertLabel.text = title
        self.timeField.text = time
    }
}

var indexPathKey: UInt8 = 0
extension NSObject {
    @objc func saveIndexPath(indexPath: IndexPath) {
        objc_setAssociatedObject(self, &indexPathKey, indexPath, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func indexPath() -> IndexPath? {
        return objc_getAssociatedObject(self, &indexPathKey) as? IndexPath
    }
}
