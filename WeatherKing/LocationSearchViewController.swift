//
//  LocationSearchViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 5. 26..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let locationManager = RWLocationManager.shared
    private let notification = NotificationCenter.default
    private var locationsFound: [RWLocation] = []
    private var isCurrentLocationUpdated: Bool = false
    
    let toolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
        locationManager.updateCurrentLocation()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
        toolbar.items = [doneBtn]
        searchBar.inputAccessoryView = toolbar
    }
    
    private func prepareObservers() {
        notification.addObserver(self, selector: #selector(onLocationUpdate), name: .CurrentLocationDidUpdated, object: nil)
    }
    
    deinit {
        notification.removeObserver(self, name: .CurrentLocationDidUpdated, object: nil)
    }
    
    @objc func onLocationUpdate() {
        isCurrentLocationUpdated = true
        tableView.reloadData()
    }
}

extension LocationSearchViewController {
    func requestSearch(for keyword: String, completion: (() -> Void)? = nil) {
        locationManager.search(for: keyword) { [weak self] locationsFound in
            self?.locationsFound = locationsFound ?? []
            self?.tableView.reloadData()
            completion?()
        }
    }
}

extension LocationSearchViewController {
    @objc func onDoneButtonTapped() {
        view.endEditing(true)
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (locationsFound.isEmpty && isCurrentLocationUpdated) || locationManager.isAuthorized == false {
            return 1
        } else if !locationsFound.isEmpty {
            return locationsFound.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let cellTitle: String
        
        if locationsFound.isEmpty && isCurrentLocationUpdated || locationManager.isAuthorized == false {
            cell = tableView.dequeueReusableCell(withIdentifier: "currentSearchCell", for: indexPath)
            cellTitle = "현재 위치로 날씨보기"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "locationSearchCell", for: indexPath)
            cellTitle = locationsFound[indexPath.row].name
        }
        
        if let locationCell = cell as? LocationSearchCell {
            locationCell.update(title: cellTitle)
        }
        
        return cell
    }
}

extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard locationsFound.indices.contains(indexPath.item) else {
            if locationManager.isAuthorized {
                locationManager.updateUserLocation(locationManager.currentLocation) { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            } else {
                let alertController: UIAlertController = UIAlertController(title: "현재 위치 확인을 위해 권한이 필요합니다.", message: "설정 > 날씨왕에서 권한 설정을 변경해주세요.", preferredStyle: .alert)
                let confirmAction: UIAlertAction = UIAlertAction(title: "확인", style: .default)
                alertController.addAction(confirmAction)
                present(alertController, animated: true, completion: nil)
            }
            return
        }
        
        let selectedLocation: RWLocation = locationsFound[indexPath.item]
        locationManager.updateUserLocation(selectedLocation) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestSearch(for: searchText)
    }
}

class LocationSearchCell: UITableViewCell {
    @IBOutlet private weak var location: UILabel!
    
    func update(title: String) {
        self.location.text = title
    }
}
