//
//  HomeBestCommentCollectionCell.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class HomeBestCommentCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var comments: [Comment] = [] {
        didSet {
            collectionView?.register(cellTypes: [.bestCommentCell])
            collectionView?.reloadData()
        }
    }
}

extension HomeBestCommentCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType: HomeCellType = .bestCommentCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
        
        if let commentCell = cell as? HomeBestCommentCell {
            commentCell.updateView(comment: comments[indexPath.item])
        }
        
        return cell
    }
}

extension HomeBestCommentCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeBestCommentCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomeCellType.bestCommentCell.size
    }
}

