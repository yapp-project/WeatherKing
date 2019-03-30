//
//  CommentCell.swift
//  Test
//
//  Created by 박진수 on 30/03/2019.
//  Copyright © 2019 박진수. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func detectTouch()
}

class CommentCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goodCountLabel: UILabel!
    @IBOutlet weak var badCountLabel: UILabel!
    
    var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.detectTouch()
    }
    
    func fill(_ comment: Comment) {
        nameLabel.text = comment.name
        commentLabel.text = comment.comment
        distanceLabel.text = String(comment.distance)
        timeLabel.text = String(comment.time)
        goodCountLabel.text = String(comment.goodCount)
        badCountLabel.text = String(comment.badCount)
    }
}
