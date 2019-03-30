//
//  DrawerViewController.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    
    var menuName = ["단위","알림 설정","피드백 보내기","앱 평가하기"]
    var menuImg = ["icDegree","icNotification","icFeedback","icReview"]
    
    fileprivate var previousTouchLocation: CGFloat?
}

extension DrawerViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        
        previousTouchLocation = firstTouch.location(in: view).x
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        
        let touchLocation: CGPoint = firstTouch.location(in: view)
        
        if let previousTouchLocation = previousTouchLocation {
            let moveOffset: CGFloat = touchLocation.x - previousTouchLocation
            (parent as? RootViewController)?.moveDrawer(offset: moveOffset)
        } else {
            previousTouchLocation = touchLocation.x
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = nil
        (parent as? RootViewController)?.finishDraggingDrawer()
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = nil
        (parent as? RootViewController)?.finishDraggingDrawer()
        super.touchesCancelled(touches, with: event)
    }
}

extension DrawerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        
        cell.cellImage.image = UIImage(named: menuImg[indexPath.row])
        cell.cellName.text = menuName[indexPath.row]
        
        return cell
    }
}

extension DrawerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click \(menuName[indexPath.row])")
        
        if menuName[indexPath.row] == "단위" {
            let stroyboard:UIStoryboard = self.storyboard!
            let nextView = stroyboard.instantiateViewController(withIdentifier: "unitNavigation")
            self.present(nextView,animated: true,completion: nil)
        } else if menuName[indexPath.row] == "알림 설정" {
            let stroyboard:UIStoryboard = self.storyboard!
            let nextView = stroyboard.instantiateViewController(withIdentifier: "alertNavigation")
            self.present(nextView,animated: true,completion: nil)
        }
    }
}

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    
}
