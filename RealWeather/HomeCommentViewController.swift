//
//  ViewController.swift
//  Test
//
//  Created by 박진수 on 30/03/2019.
//  Copyright © 2019 박진수. All rights reserved.
//

import UIKit

class HomeCommentViewController: UIViewController {
    @IBOutlet weak var commentCollectionView: UICollectionView!
    @IBOutlet weak var commentTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: CommentTextField!
    @IBOutlet weak var textFieldView: UIView!
    
    private var commentList: [Comment] = []
    private let dataController = HomeDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentCollectionView.dataSource = self
        self.commentCollectionView.delegate = self
        self.commentTextField.commentDelegate = self
  
        self.textFieldView.addBorder(side: .top, color: UIColor.CellBgColor.cgColor, thickness: 1)
        
        commentList.append(Comment(name: "코트요정", comment: "바람도 안불고 코트입기 딱이네요 ㅎㅎㅎ", distance: 5, time: 1, likeCount: 121, hateCount: 50))
        commentList.append(Comment(name: "지구멸망한다", comment: "갑자기 눈 우박 내리고 오늘 지구 최후의 날인것 같습니다", distance: 5, time: 2, likeCount: 24, hateCount: 35))
        commentList.append(Comment(name: "코트요정", comment: "바람도 안불고 코트입기 딱이네요 ㅎㅎㅎ", distance: 15, time: 3, likeCount: 53, hateCount: 16))
        commentList.append(Comment(name: "지구멸망한다", comment: "갑자기 눈 우박 내리고 오늘 지구 최후의 날인것 같습니다", distance: 1, time: 5, likeCount: 99, hateCount: 100))
        commentList.append(Comment(name: "코트요정", comment: "바람도 안불고 코트입기 딱이네요 ㅎㅎㅎ", distance: 10, time: 5, likeCount: 341, hateCount: 23))
        commentList.append(Comment(name: "지구멸망한다", comment: "갑자기 눈 우박 내리고 오늘 지구 최후의 날인것 같습니다", distance: 15, time: 7, likeCount: 123, hateCount: 5))
        commentList.append(Comment(name: "코트요정", comment: "바람도 안불고 코트입기 딱이네요 ㅎㅎㅎ", distance: 20, time: 8, likeCount: 1132, hateCount: 250))
        commentList.append(Comment(name: "지구멸망한다", comment: "갑자기 눈 우박 내리고 오늘 지구 최후의 날인것 같습니다", distance: 1, time: 12, likeCount: 121, hateCount: 144))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(appearKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disappearKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.commentTextField.endEditing(true)
    }
    
    @objc func appearKeyboard(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.commentTextFieldBottomConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom
        }
    }
    
    @objc func disappearKeyboard(notification: NSNotification) {
        self.commentTextFieldBottomConstraint.constant = 0
    }
}

extension HomeCommentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as? CommentCell else { fatalError() }
        cell.fill(commentList[indexPath.item], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.width * 100 / 375
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "commentHeader", for: indexPath) as? CommentHeaderView else { fatalError() }
        header.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
   
    
}

extension HomeCommentViewController: CommentTextFieldDelegate, CommentHeaderDelegate, CommentCellDelegate {
    func setCommentEmotion(_ emotion: CommentEmotion, index: Int) {
        switch emotion {
        case .like:
            if commentList[index].isLike {
                commentList[index].likeCount -= 1
            }
            else {
                commentList[index].likeCount += 1
            }
            commentList[index].isLike = !commentList[index].isLike
            commentCollectionView.reloadData()
        case .hate:
            if commentList[index].isHate {
                commentList[index].hateCount -= 1
            }
            else {
                commentList[index].hateCount += 1
            }
            commentList[index].isHate = !commentList[index].isHate
            commentCollectionView.reloadData()
        }
    }
    
    func registerComment() {
        guard let text = commentTextField.text else { return }
        commentList.append(Comment(name: "이름", comment: text, distance: 5, time: 5, likeCount: 5, hateCount: 5))
        commentCollectionView.reloadData()
    }
    
    func settingComment(index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "댓글 신고하기", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        commentList.forEach { index in
            
        }
    }
    
    func setRange(_ range: Range) {
        switch range {
        case .distance:
            commentList.sort(by: { $0.distance < $1.distance })
            commentCollectionView.reloadData()
        case .recent:
            commentList.sort(by: { $0.time < $1.time })
            commentCollectionView.reloadData()
        }
    }
    
    func detectTouch() {
        self.commentTextField.endEditing(true)
    }
}


