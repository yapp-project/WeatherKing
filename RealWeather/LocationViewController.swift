//
//  LocationViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 5. 16..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var location = ["서울특별시 송파구 가락1동","서울특별시 송파구 가락2동","서울특별시 송파구 가락본동","서울특별시 송파구 가락동"]
    var current = ["현재 위치로 날씨보기"]
    var isInput = false
    var locationfilter = [String]()
    var identifier = "currentCell"
    let toolbar = UIToolbar()
    var locationManager: CLLocationManager = CLLocationManager()
    let requesturl = RequestURL()
    let startURL = "http://15.164.86.162:3000/api/setting/location?"
    
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

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate {
            let latitude = String(coor.latitude)
            let longitude = String(coor.longitude)
            print("latitude : \(latitude) longitude : \(longitude)")
//            let url = "\(startURL)type=1&uid=dlflwjflehfdkeksu&lat=37.646141&lng=126.787860"
//            requesturl.RequestURL(url: url, type: .put)
        }
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
            //그 지역의 위도, 경도 전송 후 메인으로 이동
            let defaults = UserDefaults.standard
            let address = defaults.stringArray(forKey: "address_name")
            print("address ============== \(address)")
            let url = "\(startURL)type=&uid=&lat=&lng="
//            requesturl.RequestURL(url: url, type: .put)
        } else {
            print("\(current[indexPath.row])")
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            //위도, 경도 전송 후 메인으로 이동
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //키워드로 검색하는 api 연동
        locationfilter = searchText.isEmpty ? location: location.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        let url = "\(startURL)keyword=\(searchText)"
        
        
        if searchText == "" {
            isInput = false
            tableview.reloadData()
        } else {
            isInput = true
            tableview.reloadData()
        }
        requesturl.RequestURL(url: url, type: .get)
        
    }
}

class LocationCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    func update(title: String) {
        self.title.text = title
    }
}
