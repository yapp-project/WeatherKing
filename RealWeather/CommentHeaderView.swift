//
//  CommentHeaderView.swift
//  RealWeather
//
//  Created by 박진수 on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class CommentHeaderView: UICollectionReusableView {
    @IBOutlet weak var distanceBtn: UILabel!
    @IBOutlet weak var latestBtn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
}
