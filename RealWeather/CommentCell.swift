//
//  CommentCell.swift
//  Test
//
//  Created by 박진수 on 30/03/2019.
//  Copyright © 2019 박진수. All rights reserved.
//

import UIKit
enum CommentEmotion {
    case like
    case hate
}
protocol CommentCellDelegate {
    func detectTouch()
    func settingComment(index: Int)
    func setCommentEmotion(_ emotion: CommentEmotion, index: Int)
}

class CommentCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hateBtn: CommentLikeButton!
    @IBOutlet weak var likeBtn: CommentLikeButton!
    
    var delegate: CommentCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeBtn.isLike = true
        hateBtn.isLike = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.detectTouch()
    }
    
    @IBAction func settingComment(_ sender: Any) {
        print("bt!!")
        guard let indexPath = self.indexPath else { return }
        delegate?.settingComment(index: indexPath.item)
    }
    
    @IBAction func likeComment(_ sender: Any) {
        likeBtn.isChecked = !likeBtn.isChecked
        guard let indexPath = self.indexPath else { return }
        delegate?.setCommentEmotion(.like, index: indexPath.item)
    }
    
    @IBAction func hateComment(_ sender: Any) {
        hateBtn.isChecked = !hateBtn.isChecked
        guard let indexPath = self.indexPath else { return }
        delegate?.setCommentEmotion(.hate, index: indexPath.item)
    }
    
    func fill(_ comment: RWComment, indexPath: IndexPath) {
        nameLabel.text = comment.nickname
        commentLabel.text = comment.content
        distanceLabel.text = String(comment.distance) + "km"
        timeLabel.text = String(comment.time) + "분"
        likeBtn.isChecked = comment.isLike
        hateBtn.isChecked = comment.isHate
        likeBtn.setTitle(String(comment.likeCount), for: .normal)
        hateBtn.setTitle(String(comment.hateCount), for: .normal)
        self.indexPath = indexPath
    }
}
