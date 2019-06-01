//
//  CommentHeaderView.swift
//  WeatherKing
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
    @IBOutlet weak var recentBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var delegate: CommentHeaderDelegate?
    
    var isHiddenSubViews: Bool = false {
        didSet {
            if isHiddenSubViews {
                distanceBtn.isHidden = true
                recentBtn.isHidden = true
                bottomView.isHidden = true
            }
            else {
                distanceBtn.isHidden = false
                recentBtn.isHidden = false
                bottomView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        initView()
    }
    
    func initView() {
//        self.layer.applySketchShadow(color: UIColor.shadowColor30, alpha: 0.3, x: 0, y: -2, blur: 9, spread: 0)
        self.roundCorners(corners: [.topLeft, .topRight], radius: 20)
//        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
    }
    
    @IBAction func rangeDistance(_ sender: Any) {
        self.distanceBtn.setTitleColor(UIColor.charcoalGrey, for: .normal)
        self.recentBtn.setTitleColor(UIColor.shadowColor30, for: .normal)
        delegate?.setRange(.distance)
    }
    
    @IBAction func rangeRecent(_ sender: Any) {
        self.distanceBtn.setTitleColor(UIColor.shadowColor30, for: .normal)
        self.recentBtn.setTitleColor(UIColor.charcoalGrey, for: .normal)
        delegate?.setRange(.recent)
    }
}
