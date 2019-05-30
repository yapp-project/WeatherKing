//
//  ViewController.swift
//  Test
//
//  Created by 박진수 on 30/03/2019.
//  Copyright © 2019 박진수. All rights reserved.
//

import UIKit

protocol CommentDelegate {
    func getHeader(header: CommentHeaderView)
}

class HomeCommentViewController: UIViewController {
    @IBOutlet weak var commentCollectionView: UICollectionView!
    @IBOutlet weak var commentTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: CommentTextField!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyCommentImg: UIImageView!
    @IBOutlet weak var emptyCommentLabel: UILabel!
    
    private var commentList: [Comment] = []
    private var currentRange: Range = .recent
    var commentDelegate: CommentDelegate?
    
    private let dataController = HomeCommentDataController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentCollectionView.dataSource = self
        self.commentCollectionView.delegate = self
        self.commentTextField.commentDelegate = self
        self.weatherViewHeightConstraint.constant = 0
        if let bottomArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            bottomViewHeightConstraint.constant = bottomArea
        }
        
        //        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpGesture(_:)))
        //        swipe.direction = .down
        //        commentCollectionView.addGestureRecognizer(swipe)
        
        self.textFieldView.addBorder(side: .top, color: UIColor.CellBgColor.cgColor, thickness: 1)
        self.dataController.requestComment(completion: { [unowned self] data in
            guard var data = data else {
                self.commentList.removeAll()
                self.commentCollectionView.reloadData()
                self.emptyCommentImg.isHidden = false
                self.emptyCommentLabel.isHidden = false
                return
            }
            self.emptyCommentImg.isHidden = true
            self.emptyCommentLabel.isHidden = true
            self.commentList.removeAll()
            data.sort(by: { $0.likeCount > $1.likeCount })
            self.commentList = data
            self.setRange(.recent)
        })
        
        self.commentCollectionView.layer.applySketchShadow(color: UIColor.shadowColor30, alpha: 0.5, x: 0, y: -2, blur: 9, spread: 0)
        //        self.commentCollectionView.layer.masksToBounds = false
        //        self.commentCollectionView.layer.shadowColor = UIColor.shadowColor30.cgColor
        //        self.commentCollectionView.layer.shadowOpacity = 0.5
        //        self.commentCollectionView.layer.shadowOffset = CGSize(width: 0, height: -2)
        //        self.commentCollectionView.layer.shadowRadius = 9 / 2.0
        //        self.commentCollectionView.layer.shadowPath = nil
        //
        //        let timer = Timer.scheduledTimer(withTimeInterval: 100.0, repeats: true, block: { [unowned self] _ in
        //            self.dataController.requestComment(completion: { [unowned self] data in
        //                guard var data = data else {
        //                    self.commentList.removeAll()
        //                    self.commentCollectionView.reloadData()
        //                    self.emptyCommentImg.isHidden = false
        //                    self.emptyCommentLabel.isHidden = false
        //                    return
        //                }
        //                self.commentList.removeAll()
        //                data.sort(by: { $0.likeCount < $1.likeCount })
        //                self.commentList = data
        //                self.setRange(.recent)
        //            })
        //        })
        
        
        
        //        commentList.append(Comment(name: "언더아머", comment: "3대 몇 치냐?", distance: 20, time: 8, likeCount: 1132, hateCount: 250))
        //        commentList.append(Comment(name: "주륵주륵", comment: "밖에 비 온다 주륵주륵", distance: 10, time: 5, likeCount: 341, hateCount: 23))
        //        commentList.append(Comment(name: "치킨", comment: "치킨 먹고 싶다", distance: 15, time: 7, likeCount: 123, hateCount: 5))
        //
        //        commentList.append(Comment(name: "코트요정", comment: "바람도 안불고 코트입기 딱이네요 ㅎㅎㅎ", distance: 5, time: 1, likeCount: 121, hateCount: 50))
        //
        //        commentList.append(Comment(name: "지구멸망한다", comment: "갑자기 눈 우박 내리고 오늘 지구 최후의 날인것 같습니다", distance: 5, time: 2, likeCount: 24, hateCount: 35))
        //        commentList.append(Comment(name: "구구", comment: "구구", distance: 15, time: 3, likeCount: 53, hateCount: 16))
        //        commentList.append(Comment(name: "꽝꽝쾅쾅", comment: "지구 멸망하겠다.", distance: 1, time: 5, likeCount: 99, hateCount: 100))
        //
        //
        //
        //        commentList.append(Comment(name: "피카츄", comment: "피~카츄!", distance: 3, time: 12, likeCount: 121, hateCount: 144))
        //        commentList.append(Comment(name: "날씨왕", comment: "날씨 좋네요.!", distance: 30, time: 25, likeCount: 78, hateCount: 2))
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
    
    @objc func swipeUpGesture(_ sender: UISwipeGestureRecognizer) {
    }
    
    func registerComment() {
        guard let text = commentTextField.text, text.isEmpty == false else {
            return
        }
        if commentList.count <= 3 {
            commentList.append(Comment(name: "날씨왕", comment: text, distance: 1, time: 0, likeCount: 0, hateCount: 0))
        }
        else {
            commentList.insert(Comment(name: "날씨왕", comment: text, distance: 1, time: 0, likeCount: 0, hateCount: 0), at: 3)
        }
        commentCollectionView.reloadData()
        dataController.setComment(text, completion: { error in
            
            if error != nil {
                // 예외처리
            }
        })
    }
    
    func setRange(_ range: Range) {
        guard commentList.count > 3 else {
            commentCollectionView.reloadData()
            return
            
        }
        switch range {
        case .distance:
            commentList[3..<commentList.count].sort(by: { $0.distance < $1.distance })
            commentCollectionView.reloadData()
        case .recent:
            commentList[3..<commentList.count].sort(by: { $0.time < $1.time })
            commentCollectionView.reloadData()
        }
    }
}

extension HomeCommentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as? CommentCell else { fatalError() }
        let index = indexPath.item
        if index < 3 { cell.isHiddenCrown = false }
        cell.fill(commentList[index], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.width * 100 / 375
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "commentHeader", for: indexPath) as? CommentHeaderView else { fatalError() }
        header.initView()
        header.delegate = self
        header.isUserInteractionEnabled = true
        commentDelegate?.getHeader(header: header)
        return header
    }
    
}

extension HomeCommentViewController: CommentTextFieldDelegate, CommentHeaderDelegate, CommentCellDelegate {
    func setCommentEmotion(_ emotion: CommentEmotion, index: Int) {
        var state: CommentState = .like
        switch emotion {
        case .like:
            if commentList[index].isLike {
                commentList[index].likeCount -= 1
                state = .cancelLike
            }
            else {
                commentList[index].likeCount += 1
            }
            commentList[index].isLike = !commentList[index].isLike
            commentCollectionView.reloadData()
            
        case .hate:
            if commentList[index].isHate {
                commentList[index].hateCount -= 1
                state = .cancelDisLike
            }
            else {
                commentList[index].hateCount += 1
                state = .dislike
            }
            commentList[index].isHate = !commentList[index].isHate
            commentCollectionView.reloadData()
        }
        dataController.reactComment(commentList[index].id, state: state, completion: { error in
            if error != nil {
                // 예외처리
            }
        })
    }
    
    
    
    func settingComment(index: Int) {
        if commentList[index].name == "이름" {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "댓글 삭제하기", style: .destructive, handler: { [unowned self] _ in
                let removeAlert = UIAlertController(title: nil, message: "댓글을 삭제하시겠어요?", preferredStyle: .alert)
                removeAlert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
                removeAlert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [unowned self] _ in
                    self.commentList.remove(at: index)
                    self.commentCollectionView.reloadData()
                    self.commentCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.dataController.removeComment(self.commentList[index].id, completion: { error in
                        if error != nil {
                            // 예외처리
                        }
                    })
                }))
                alert.dismiss(animated: true, completion: nil)
                self.present(removeAlert, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "댓글 신고하기", style: .destructive, handler: { [unowned self] _ in
                let reportAlert = UIAlertController(title: nil, message: "신고하는 이유가 무엇인가요?", preferredStyle: .actionSheet)
                reportAlert.addAction(UIAlertAction(title: "욕설 또는 음란성", style: .destructive, handler: nil))
                reportAlert.addAction(UIAlertAction(title: "홍보 또는 개인정보 노출", style: .destructive, handler: nil))
                reportAlert.addAction(UIAlertAction(title: "날씨와 무관한 내용", style: .destructive, handler: nil))
                reportAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                alert.dismiss(animated: true, completion: nil)
                self.present(reportAlert, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    func detectTouch() {
        self.commentTextField.endEditing(true)
    }
}


