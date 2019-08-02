//
//  SettingDrawerViewController.swift
//  WeatherKing
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit
import MessageUI

enum MenuSetting: String, CaseIterable {
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
            return "피드백 보내기"
        case .review:
            return "앱 평가하기"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .degree:
            return #imageLiteral(resourceName: "icDegree")
        case .notification:
            return #imageLiteral(resourceName: "icNotification")
        case .feedback:
            return #imageLiteral(resourceName: "icFeedback")
        case .review:
            return #imageLiteral(resourceName: "icReview")
        }
    }
}

class SettingDrawerViewController: UIViewController {
    @IBOutlet private weak var nicknameButtonView: UIButton!
    
    private let menuDatasource: [MenuSetting] = MenuSetting.allCases
    private let notification: NotificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNickNameLabel()
        prepareObservers()
    }
    
    private func prepareObservers() {
        notification.addObserver(self, selector: #selector(updateNickNameLabel), name: .LoginSuccess, object: nil)
        notification.addObserver(self, selector: #selector(updateNickNameLabel), name: .UserNicknameDidChanged, object: nil)
    }
    
    deinit {
        notification.removeObserver(self, name: .LoginSuccess, object: nil)
        notification.removeObserver(self, name: .UserNicknameDidChanged, object: nil)
    }
    
    @objc func updateNickNameLabel() {
        let nickname: String = RWLoginManager.shared.user?.nickname ?? "미등록"
        nicknameButtonView.setTitle(nickname, for: .normal)
    }
}

extension SettingDrawerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menu: MenuSetting = menuDatasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath)
        let menuCell = cell as? SettingDrawerMenuCell
        
        menuCell?.updateView(image: menu.image, title: menu.title)
    
        return cell
    }
}

extension SettingDrawerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menu: MenuSetting = menuDatasource[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if menu == .degree || menu == .notification {
            performSegue(withIdentifier: menu.rawValue, sender: nil)
        } else if menu == .feedback {
            let alert = UIAlertController(title: "더 나은 날씨왕을 위해 아쉬운 점을 알려줄래요?", message: "", preferredStyle: .alert)
            let afterBtn = UIAlertAction(title: "나중에 하기", style: .default, handler: nil)
            let feedbackBtn = UIAlertAction(title: "피드백 보내기", style: .default, handler: { [weak self] action in
                guard let `self` = self else {
                    return
                }
                
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            })
            alert.addAction(afterBtn)
            alert.addAction(feedbackBtn)
            self.present(alert,animated: true, completion: nil)
        } else if menu == .review {
            let alert = UIAlertController(title: "날씨왕이 도움 되고 있다면 앱스토어에 리뷰를 남겨주세요! 날씨왕 팀에게 큰 힘이 될거에요.", message: "", preferredStyle: .alert)
            let afterBtn = UIAlertAction(title: "나중에 하기", style: .default, handler: nil)
            let reviewBtn = UIAlertAction(title: "리뷰 쓰러 가기", style: .default, handler: { action in
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

extension SettingDrawerViewController {
    @IBAction func onEditNickNameButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "nickname", sender: nil)
    }
    
    @IBAction func onPrivacyGuideButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "privacy", sender: nil)
    }
    
    @IBAction func onSignOutButtonTapped(_ sender: UIButton) {
        RWLoginManager.shared.logout()
        (parent as? RootViewController)?.closeDrawer()
    }
}

extension SettingDrawerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // viewWidth - leftInset
        return CGSize(width: view.frame.width - 21, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension SettingDrawerViewController: MFMailComposeViewControllerDelegate {
    
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
class SettingDrawerMenuCell: UICollectionViewCell {
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var cellName: UILabel!
    
    func updateView(image: UIImage?, title: String) {
        self.cellImage.image = image
        self.cellName.text = title
    }
    
    override func saveIndexPath(indexPath: IndexPath) {
        super.saveIndexPath(indexPath: indexPath)
        cellName.saveIndexPath(indexPath: indexPath)
    }
}
