//
//  AlldayAlertViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class AlldayAlertViewController: UIViewController {

    let allday = ["아침","저녁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
extension AlldayAlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allday.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allday", for: indexPath) as! AlldayTableViewCell
        
        return cell
    }
}

extension AlldayAlertViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click \(allday[indexPath.row])")
    }
}

class AlldayTableViewCell: UITableViewCell {
    
}
