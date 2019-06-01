//
//  DrawerViewController.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit
import MessageUI

enum MenuSetting: CaseIterable {
    case degree
    case notification
    case feedback
    case review
    
    var title: String {
        switch self {
        case .degree:
            return "단위"
        case .notification:
            return "알림설정"
        case .feedback:
            return "피드백 보내지"
        case .review:
            return "앱 평가하기"
        }
    }
}

class DrawerViewController: UIViewController {
    
    var menuImg = ["icDegree","icNotification","icFeedback","icReview"]
    var menuDatasource: [MenuSetting] = MenuSetting.allCases
    fileprivate var previousTouchLocation: CGFloat?
    
    @IBAction func ModifiyNicknameAction(_ sender: Any) {
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "settingNick") {
            present(nextView,animated: true,completion: nil)
        }
    }
    @IBAction func ModifiyNicknameAction02(_ sender: Any) {
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "settingNick") {
            present(nextView,animated: true,completion: nil)
        }
    }
    
    @IBAction func InformationAction(_ sender: Any) {
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "webviewNavigation") {
            present(nextView, animated: true, completion: nil)
        }
    }
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
        return menuDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType: MenuSetting = menuDatasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath)
        let menuCell = cell as? MenuCollectionViewCell
        
        let image = UIImage(named: menuImg[indexPath.row])
        let title = cellType.title
        
        menuCell?.updateView(image: image, title: title)
    
        return cell
    }
}

extension DrawerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType: MenuSetting = menuDatasource[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if cellType == .degree {
            if let nextView = storyboard?.instantiateViewController(withIdentifier: "unitNavigation") {
                present(nextView, animated: true, completion: nil)
            }
        } else if cellType == .notification {
            if let nextView = storyboard?.instantiateViewController(withIdentifier: "alertNavigation") {
                present(nextView, animated: true, completion: nil)
            }
        } else if cellType == .feedback {
            let alert = UIAlertController(title: "더 나은 날씨왕을 위해 아쉬운 점을 알려줄래요?", message: "", preferredStyle: .alert)
            let afterBtn = UIAlertAction(title: "나중에 하기", style: .default, handler: nil)
            let feedbackBtn = UIAlertAction(title: "피드백 보내기", style: .default, handler: { Action in
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                    print("can send mail")
                } else {
                    self.showSendMailErrorAlert()
                }
            })
            alert.addAction(afterBtn)
            alert.addAction(feedbackBtn)
            self.present(alert,animated: true, completion: nil)
        } else if cellType == .review {
            let alert = UIAlertController(title: "날씨왕이 도움 되고 있다면 앱스토어에 리뷰를 남겨주세요! 날씨왕 팀에게 큰 힘이 될거에요.", message: "", preferredStyle: .alert)
            let afterBtn = UIAlertAction(title: "나중에 하기", style: .default, handler: nil)
            let reviewBtn = UIAlertAction(title: "리뷰 쓰러 가기", style: .default, handler: { Action in
                let appID = "109099ab6216b849f8ac4ee65bf3510761637288"  //  수정
                
                if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(appID)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(reviewURL)
                    }
                }
            })
            alert.addAction(afterBtn)
            alert.addAction(reviewBtn)
            self.present(alert,animated: true, completion: nil)
        }
    }
}

extension DrawerViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["weatherking4u@gmail.com"])
        mailComposerVC.setSubject("피드백 보내기")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", delegate: self, cancelButtonTitle: "확인")
        sendMailErrorAlert.show()
    }
}

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    
    func updateView(image: UIImage?, title: String ) {
        self.cellImage.image = image
        self.cellName.text = title
    }
    
    override func saveIndexPath(indexPath: IndexPath) {
        super.saveIndexPath(indexPath: indexPath)
        cellName.saveIndexPath(indexPath: indexPath)
    }
}
