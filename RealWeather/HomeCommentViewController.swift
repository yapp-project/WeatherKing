//
//  HomeCommentViewController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeCommentViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate var datasource: [Comment] = []
    
    var scrollView: UIScrollView {
        return collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDummyData()
    }
    
    fileprivate func setUpDummyData() {
        let comment1: Comment = Comment()
        comment1.name = "익명의 오소리"
        comment1.commentText = "오늘 진짜 추워요. 패딩 입으세요!"
        comment1.time = "3시간 전"
        comment1.likeCount = Int.random(in: 0..<30)
        
        let comment2: Comment = Comment()
        comment2.name = "익명의 너구리"
        comment2.commentText = "따뜻하게 입으세요. 정말 춥네요 오늘.."
        comment2.time = "2시간 전"
        comment2.likeCount = Int.random(in: 0..<30)
        
        let comment3: Comment = Comment()
        comment3.name = "익명의 출근러"
        comment3.commentText = "이런 날에 출근이라니"
        comment3.time = "2시간 전"
        comment3.likeCount = Int.random(in: 0..<30)
        
        let comment4: Comment = Comment()
        comment4.name = "익명의 해커톤 참여자"
        comment4.commentText = "지금 출근하는 사람 좋아요 ㄱㄱ"
        comment4.time = "2시간 전"
        comment4.likeCount = Int.random(in: 0..<30)
        
        let comment5: Comment = Comment()
        comment5.name = "바니바니"
        comment5.commentText = "이런 날엔 호빵이 먹고 싶다"
        comment5.time = "2시간 전"
        comment5.likeCount = Int.random(in: 0..<30)
        
        let comment6: Comment = Comment()
        comment6.name = "감기남"
        comment6.commentText = "감기인데 오늘 또 춥네요. 에구"
        comment6.time = "2시간 전"
        comment6.likeCount = Int.random(in: 0..<30)
        
        let comment7: Comment = Comment()
        comment7.name = "여긴 어디인가 나는 누구인가"
        comment7.commentText = "나는 잠이 자고 싶다"
        comment7.time = "1시간 전"
        comment7.likeCount = Int.random(in: 0..<30)
        
        let comment8: Comment = Comment()
        comment8.name = "피카츄"
        comment8.commentText = "요새 휴대용 손난로 쓰는 중인데 좋네요 ㅋㅋ 써보세요"
        comment8.time = "1시간 전"
        comment8.likeCount = Int.random(in: 0..<30)
        
        let comment9: Comment = Comment()
        comment9.name = "오날씨"
        comment9.commentText = "요새 진짜 왜 이렇게 춥냐"
        comment9.time = "1시간 전"
        comment9.likeCount = Int.random(in: 0..<30)
        
        let comment10: Comment = Comment()
        comment10.name = "늙은이"
        comment10.commentText = "제발 미세먼지좀 가져가"
        comment10.time = "방금"
        comment10.likeCount = Int.random(in: 0..<30)
        
        datasource = [
            comment1,
            comment2,
            comment3,
            comment4,
            comment5,
            comment6,
            comment7,
            comment8,
            comment9,
            comment10
        ]
        collectionView.reloadData()
    }
    
    // MARK: 추후 구조 수정
    func registerComment(_ text: String) {
        let dummyComment = Comment()
        dummyComment.commentText = text
        dummyComment.name = "프로출근러"
        dummyComment.time = "방금"
        dummyComment.profileImage = nil
        dummyComment.likeCount = Int.random(in: 0..<100)
        
        datasource.append(dummyComment)
        collectionView.reloadData()
        
        let lastIndex = datasource.count - 1
        collectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .top, animated: true)
    }
}

extension HomeCommentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCommentCell", for: indexPath)
        
        if let commentCell = cell as? HomeCommentCell {
            let commentData: Comment = datasource[indexPath.item]
            commentCell.updateUI(with: commentData)
        }
        
        return cell
    }
}

extension HomeCommentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeCommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 472, left: 0, bottom: 90, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 65)
    }
}

extension HomeCommentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        (parent as? HomeViewController)?.scrollTopView(scrollView)
    }
}

class HomeCommentCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var profileImageView: UIImageView!
    @IBOutlet fileprivate weak var likeImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var likeCountLabel: UILabel!
    
    func updateUI(with comment: Comment) {
//        profileImageView.image = comment.profileImage
//        likeImageView.image = comment.isLiked ? comment.profileImage : comment.profileImage
        nameLabel.text = comment.name
        commentLabel.text = comment.commentText
        timeLabel.text = "\(comment.time)" // 추후 변경 필요
        likeCountLabel.text = "\(comment.likeCount)"
    }
}
