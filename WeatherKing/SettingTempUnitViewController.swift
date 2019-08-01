//
//  SettingTempUnitViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

enum WKTemperatureUnit: Int, CaseIterable {
    case celsius
    case fahrenheit
    
    var symbolText: String {
        switch self {
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        }
    }
}

class SettingTempUnitViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    let menuDatasource: [WKTemperatureUnit] = WKTemperatureUnit.allCases
    var selectedTempUnit: WKTemperatureUnit = .celsius {
        didSet {
            UserDefaultsManager.TemperatureUnitSetting.set(selectedTempUnit.rawValue)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTempUnitSetting()
    }
    
    private func loadTempUnitSetting() {
        let tempUnitIndex: Int = UserDefaultsManager.TemperatureUnitSetting.get()
        selectedTempUnit = WKTemperatureUnit(rawValue: tempUnitIndex) ?? .celsius
    }
}

extension SettingTempUnitViewController {
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingTempUnitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTempUnitCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        
        if let unitCell = cell as? SettingTempUnitCell {
            let tempUnit = menuDatasource[indexPath.row]
            let isSelected = tempUnit == selectedTempUnit
            unitCell.update(title: tempUnit.symbolText, isSelected: isSelected)
        }
        return cell
    }
}

extension SettingTempUnitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTempUnit = menuDatasource[indexPath.row]
    }
}

class SettingTempUnitCell: UITableViewCell {
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitCheck: UIImageView!
    
    static let identifier: String = "unitCell"
    
    func update(title: String, isSelected: Bool) {
        self.unitLabel.attributedString = title
        self.unitLabel.textColor = isSelected ? .purpleishBlue : .charcoalGrey
        self.unitCheck.isHidden = !isSelected
    }
}
