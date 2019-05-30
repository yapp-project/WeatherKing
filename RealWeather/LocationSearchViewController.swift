//
//  LocationSearchViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 5. 26..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSearchViewController: UIViewController {

    @IBOutlet weak var search_bar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    var current = ["현재 위치로 날씨보기"]
    var isInput = false
    var locationfilter = [String]()
    var identifier = "currentCell"
    let toolbar = UIToolbar()
    var locationManager: CLLocationManager = CLLocationManager()
    let locationKeyword = LocationKeyword()
    let startURL = "http://15.164.86.162:3000/api/setting/location?"
    let defaults = UserDefaults.standard
    var rwUser: RWUser?
    var address_name: [String] = [""]

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.BarAction))
        toolbar.items = [doneBtn]
        search_bar.inputAccessoryView = toolbar
        
        defaults.removeObject(forKey: "address_name")
        
        
    }
    @objc func BarAction() {
        view.endEditing(true)
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func RequestURL(url: String, type: HTTPMethod, body: Data? = nil) {
        print("\(url) === \(type.rawValue)")
        let encoed = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoed)
        var request = URLRequest(url: url!)
        
        request.httpMethod = type.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error : \(error!.localizedDescription)")
                return
            }
            do {
                if let anyData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:String]] {
                    
                    var address_array:[String] = []
                    var lat_array:[String] = []
                    var lng_array:[String] = []
                    let locationKeyword = LocationKeyword()

                    if type == .get {
                        for address in anyData {
                            if let address_name = address["address_name"] {
                                if let longitude = address["x"] {
                                    if let latitude = address["y"] {
                                        print("\(address_name)")
                                        address_array.append(address_name)
                                        lat_array.append(latitude)
                                        lng_array.append(longitude)
                                    }
                                }
                            }
                            let defaults = UserDefaults.standard
                            defaults.set(address_array, forKey: "address_name")
                            defaults.set(lng_array, forKey: "x")
                            defaults.set(lat_array, forKey: "y")
                            locationKeyword.LocationKeyword(_location: address_array, longitude: lng_array, latitude: lat_array)
                            DispatchQueue.main.sync {
                                self.tableview.reloadData()
                            }
                        }
                    } else if type == .put {
                        print("\(anyData)")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
extension LocationSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate {
            let latitude = String(coor.latitude)
            let longitude = String(coor.longitude)
            let userId = rwUser?.uniqueID
            let loginType = rwUser?.loginMethod
            print("latitude : \(latitude) longitude : \(longitude)")
            let url = "\(startURL)type=2&uid=8156087164dea5fc447685e589be33c638c342d8233d062ab37baf28623da6e5da199bf9ab1cb286ca2639e9ab81e8f5ed24bc5e320c1fdb4ba2b8df7517f7ec&lat=\(latitude)&lng=\(longitude)"
            RequestURL(url: url, type: .put)
        }
    }
}

extension LocationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInput == true {
            return address_name.count
        } else {
            return current.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isInput == true {
            identifier = "locationSearchCell"
        } else {
            identifier = "currentSearchCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let locationCell = cell as? LocationSearchCell {
            address_name = defaults.stringArray(forKey: "address_name") ?? [""]
            if address_name == [""] {
                locationCell.update(title: "")
            } else {
                locationCell.update(title: address_name[indexPath.row])
            }
            
        }
        return cell
    }
}

extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInput == true {
            print("\(address_name[indexPath.row])")
            
            let lat = defaults.stringArray(forKey: "y")
            let lng = defaults.stringArray(forKey: "x")
            var longitude = ""
            var latitude = ""
            let userId = rwUser?.uniqueID
            let loginType = rwUser?.loginMethod.rawValue
            
            for _ in address_name {
                    if address_name[indexPath.row] == address_name[indexPath.row] {
                        latitude = lat?[indexPath.row] ?? ""
                        longitude = lng?[indexPath.row] ?? ""
                    }
                }
            
            let url = "\(startURL)type=2&uid=8156087164dea5fc447685e589be33c638c342d8233d062ab37baf28623da6e5da199bf9ab1cb286ca2639e9ab81e8f5ed24bc5e320c1fdb4ba2b8df7517f7ec&lat=\(latitude)&lng=\(longitude)"
            RequestURL(url: url, type: .put)
            
            
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

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let url = "\(startURL)keyword=\(searchText)"
        RequestURL(url: url, type: .get)
        
        if searchText == "" {
            isInput = false
            defaults.removeObject(forKey: "address_name")
            tableview.reloadData()
        } else {
            if address_name == [""] {
                isInput = false
            }
            isInput = true
            tableview.reloadData()
        }
    }
}

class LocationSearchCell: UITableViewCell {
    
    @IBOutlet weak var location: UILabel!
    
    func update(title: String) {
        self.location.text = title
    }
}
