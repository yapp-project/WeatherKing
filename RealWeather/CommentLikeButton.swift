//
//  CommentLikeButton.swift
//  RealWeather
//
//  Created by 박진수 on 2019. 3. 31..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class CommentLikeButton: UIButton {
    var isLike: Bool = true {
        didSet {
            if isLike {
                self.setImage(UIImage(named: "icLikeDown"), for: .normal)
            } else {
                self.setImage(UIImage(named: "icHateDown"), for: .normal)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            isChecked = !isChecked
        }
    }
    
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                if isLike {
                    self.setImage(UIImage(named: "icLikeUp"), for: .normal)
                    self.setTitleColor(UIColor.mainColor, for: .normal)
                } else {
                    self.setImage(UIImage(named: "icHateUp"), for: .normal)
                    self.setTitleColor(UIColor.mainColor, for: .normal)
                }
            }
            else {
                if isLike {
                    self.setImage(UIImage(named: "icLikeDown"), for: .normal)
                    self.setTitleColor(UIColor.grayText, for: .normal)
                } else {
                    self.setImage(UIImage(named: "icHateDown"), for: .normal)
                    self.setTitleColor(UIColor.grayText, for: .normal)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
