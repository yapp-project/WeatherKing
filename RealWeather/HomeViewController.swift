//
//  HomeViewController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

public enum HomeCellType {
    case weatherCardCollection
    case weatherCard
    case weatherMenu
    case bestCommentCollection
    case bestComment
    
    var identifier: String {
        switch self {
        case .weatherCardCollection:
            return "HomeWeatherCardCollectionCell"
        case .weatherCard:
            return "HomeWeatherCardCell"
        case .weatherMenu:
            return "HomeWeatherMenuCell"
        case .bestCommentCollection:
            return "HomeBestCommentCollectionCell"
        case .bestComment:
            return "HomeBestCommentCell"
        }
    }
    
    var size: CGSize {
        switch self {
        case .weatherCardCollection:
            return CGSize(width: UIScreen.main.bounds.width, height: 410)
        case .weatherCard:
            return CGSize(width: UIScreen.main.bounds.width, height: 390)
        case .weatherMenu:
            return CGSize(width: 24, height: 17)
        case .bestCommentCollection:
            return CGSize(width: UIScreen.main.bounds.width, height: 90)
        case .bestComment:
            return CGSize(width: UIScreen.main.bounds.width, height: 90)
        }
    }
}

class HomeViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var backgroundColorView: UIView!
    @IBOutlet fileprivate weak var commentContainer: UIView!
    
    fileprivate let homeDataController: HomeDataController = HomeDataController()
    fileprivate let homeCellDatasource: [HomeCellType] = [.bestCommentCollection, .weatherCardCollection]
    fileprivate var commentViewController: HomeCommentViewController!
    fileprivate var notification: NotificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
        prepareCells()
        updateView()
    }
    
    fileprivate func prepareCells() {
        collectionView.register(cellTypes: homeCellDatasource)
    }
    
    fileprivate func prepareObservers() {
        
    }
}

extension HomeViewController {
    func updateView() {
//        commentContainer.layer.applySketchShadow(color: .shadowColor30, alpha: 1.0, x: 0, y: -2, blur: 9, spread: 0)
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeComment" {
            commentViewController = segue.destination as? HomeCommentViewController
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType: HomeCellType = homeCellDatasource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
        
        if let weatherCollectionCell = cell as? HomeWeatherCardCollectionCell {
            var dummyCard: WeatherCard = WeatherCard()
            dummyCard.mainColor = .lightishBlue
            dummyCard.currentTemp = 30
            dummyCard.description = "어제보다 포근해요"
            dummyCard.estimatedTemp = 33
            dummyCard.minTemp = 29
            dummyCard.maxTemp = 33
            
            weatherCollectionCell.cardDatasource.updateValue([dummyCard, dummyCard, dummyCard], forKey: .today)
            weatherCollectionCell.selectedMenu = .today
        } else if let bestCommentCollectionCell = cell as? HomeBestCommentCollectionCell {
            var dummyComment1: Comment = Comment()
            
            bestCommentCollectionCell.comments = [dummyComment1, dummyComment1]
//            bestCommentCollectionCell.comments = comments
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCellDatasource.count
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeCellDatasource[indexPath.item].size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension UICollectionView {
    // Home 이외에서도 사용될 경우 CellType으로 통합
    func register(cellTypes: [HomeCellType]) {
        cellTypes.forEach {
            let nib: UINib = UINib(nibName: $0.identifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: $0.identifier)
        }
    }
}
