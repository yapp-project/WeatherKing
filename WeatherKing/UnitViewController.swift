//
//  UnitViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit


class UnitViewController: UIViewController {
    var unit = ["℃","℉"]
    var unitCheck = ["check",""]
    var image: UIImage?
    var titleColor: UIColor? = UIColor(red: 52, green: 58, blue: 64)
    var checkImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension UnitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath)
        cell.saveIndexPath(indexPath: indexPath)
        let unitCell = cell as? UnitTableViewCell
        
        unitCell?.update(title: unit[indexPath.row], check: UIImage(named: unitCheck[indexPath.row]))
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension UnitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("click \(unit[indexPath.row])")
        
        if indexPath.row == 0 {
            tableView.reloadData()
            unitCheck.removeAll()
            unitCheck.insert("check", at: 0)
            unitCheck.insert("", at: 1)
        } else if indexPath.row == 1 {
            tableView.reloadData()
            unitCheck.remove(at: 0)
            unitCheck.insert("", at: 0)
            unitCheck.insert("check", at: 1)
        } else {
            print("else")
        }
    }
}

class UnitTableViewCell: UITableViewCell {
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitCheck: UIImageView!
    
    override func saveIndexPath(indexPath: IndexPath) {
        super.saveIndexPath(indexPath: indexPath)
        unitLabel.saveIndexPath(indexPath: indexPath)
        
    }
    
    func update(title: String, check: UIImage?) {
        self.unitLabel.text = title
        self.unitCheck.image = check
    }
}
