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
    var commentList: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentCollectionView.dataSource = self
        self.commentCollectionView.delegate = self
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = UIColor.mainColor
        self.textFieldView.addBorder(side: .top, color: UIColor.CellBgColor.cgColor, thickness: 1)
        
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
        commentList.append(Comment(name: "ee", comment: "eee", distance: 1, time: 1, goodCount: 1, badCount: 1))
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

extension HomeCommentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as? CommentCell else { fatalError() }
        cell.fill(commentList[indexPath.item])
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
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func detectTouch() {
        self.commentTextField.endEditing(true)
    }
    
}

extension HomeCommentViewController: CommentTextFieldDelegate {
    func registerComment() {
    }
}


