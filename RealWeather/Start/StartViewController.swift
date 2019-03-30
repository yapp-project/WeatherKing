//
//  StartViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    let alertTitle = ["매일 알림","비소식 알림","미세먼지 알림"]
    var alertCheck = ["checked","checked","checked"]
    let mainTitle = "푸시 알람을 사용해 최신 일기 예보를 확인하세요"
    
    
    @IBOutlet weak var okBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func UseAlertAction(_ sender: Any) {
        let stroyboard:UIStoryboard = self.storyboard!
        let nextView = stroyboard.instantiateViewController(withIdentifier: "nickChecked")
        self.present(nextView,animated: true,completion: nil)
    }
    @IBAction func LaterAlertAction(_ sender: Any) {
        
    }
}

extension StartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alertTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startCell", for: indexPath) as! StartCollectionCell
        
        cell.title.text = alertTitle[indexPath.row]
        cell.check.setImage(UIImage(named: alertCheck[indexPath.row]), for: .normal)
        cell.title.tag = indexPath.row
        return cell
    }
}

extension StartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if alertCheck[0] == "checked" {
                alertCheck.remove(at: 0)
                alertCheck.insert("rectangle5Copy2", at: 0)
            } else {
                alertCheck.remove(at: 0)
                alertCheck.insert("checked", at: 0)
            }
            collectionView.reloadData()
        } else if indexPath.row == 1 {
            if alertCheck[1] == "checked" {
                alertCheck.remove(at: 1)
                alertCheck.insert("rectangle5Copy2", at: 1)
            } else {
                alertCheck.remove(at: 1)
                alertCheck.insert("checked", at: 1)
            }
            collectionView.reloadData()
        } else if indexPath.row == 2 {
            if alertCheck[2] == "checked" {
                alertCheck.remove(at: 2)
                alertCheck.insert("rectangle5Copy2", at: 2)
            } else {
                alertCheck.remove(at: 2)
                alertCheck.insert("checked", at: 2)
            }
            collectionView.reloadData()
        }
    }
}

class StartCollectionCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var check: UIButton!
}
