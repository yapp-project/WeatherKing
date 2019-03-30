//
//  UnitViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class UnitViewController: UIViewController {
    var unit = ["℃","℉"]
    var unitCheck = ["",""]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath) as! UnitTableViewCell
        
        cell.unitCheck.image = UIImage(named: unitCheck[indexPath.row])
        cell.unitLabel.text = unit[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension UnitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click \(unit[indexPath.row])")
        let vc = UnitTableViewCell()
        
        if unit[indexPath.row] == "℃" {
//            vc.unitLabel.textColor = UIColor(red: 78, green: 92, blue: 239, alpha: 1)
//            vc.unitCheck.image = UIImage(named: "check")
        }
    }
}

class UnitTableViewCell: UITableViewCell {
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitCheck: UIImageView!
}
