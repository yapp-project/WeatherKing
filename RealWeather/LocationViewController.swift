//
//  LocationViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 5. 16..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var location = ["서울특별시 송파구 가락1동","서울특별시 송파구 가락2동","서울특별시 송파구 가락본동","서울특별시 송파구 가락동"]
    var current = ["현재 위치로 날씨보기"]
    var isInput = false
    var locationfilter = [String]()
    var identifier = "currentCell"
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.BarAction))
        toolbar.items = [doneBtn]
        searchbar.inputAccessoryView = toolbar
    }
    @objc func BarAction() {
        view.endEditing(true)
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInput == true {
            return locationfilter.count
        } else {
            return current.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isInput == true {
            identifier = "locationCell"
        } else {
            identifier = "currentCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath)
        if let locationCell = cell as? LocationCell {
            locationCell.update(title: locationfilter[indexPath.row])
        }
        return cell
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInput == true {
            print("\(locationfilter[indexPath.row])")
        } else {
            print("\(current[indexPath.row])")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        locationfilter = searchText.isEmpty ? location: location.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        if searchText == "" {
            isInput = false
            tableview.reloadData()
        } else {
            isInput = true
            tableview.reloadData()
        }
    }
}

class LocationCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    func update(title: String) {
        self.title.text = title
    }
}
