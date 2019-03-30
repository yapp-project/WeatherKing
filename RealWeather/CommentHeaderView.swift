//
//  CommentHeaderView.swift
//  RealWeather
//
//  Created by 박진수 on 2019. 3. 30..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

enum Range {
    case distance
    case recent
}
protocol CommentHeaderDelegate {
    func setRange(_ range: Range)
}

class CommentHeaderView: UICollectionReusableView {
    @IBOutlet weak var distanceBtn: UIButton!
    @IBOutlet weak var recentLabel: UIButton!
    
    var delegate: CommentHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        self.layer.applySketchShadow(color: UIColor.shadowColor30, alpha: 0.3, x: 0, y: -2, blur: 9, spread: 0)
    }
    
    
    @IBAction func rangeDistance(_ sender: Any) {
        self.distanceBtn.setTitleColor(UIColor.charcoalGrey, for: .normal)
        self.recentLabel.setTitleColor(UIColor.shadowColor30, for: .normal)
        delegate?.setRange(.distance)
    }
    
    @IBAction func rangeRecent(_ sender: Any) {
        self.distanceBtn.setTitleColor(UIColor.shadowColor30, for: .normal)
        self.recentLabel.setTitleColor(UIColor.charcoalGrey, for: .normal)
        delegate?.setRange(.recent)
    }
}
