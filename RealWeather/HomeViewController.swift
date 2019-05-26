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
    case weatherTempCard
    case weatherStatusCard
    case weatherDustCard
    case weatherMenu
    case bestCommentCollection
    case bestComment
    
    var identifier: String {
        switch self {
        case .weatherCardCollection:
            return "HomeWeatherCardCollectionCell"
        case .weatherTempCard:
            return "HomeWeatherTempCardCell"
        case .weatherStatusCard:
            return "HomeWeatherStatusCardCell"
        case .weatherDustCard:
            return "HomeWeatherDustCardCell"
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
            return CGSize(width: UIScreen.main.bounds.width, height: 420)
        case .weatherTempCard, .weatherStatusCard, .weatherDustCard:
            return CGSize(width: UIScreen.main.bounds.width, height: 390)
        case .weatherMenu:
            return CGSize(width: 24, height: 17)
        case .bestCommentCollection, .bestComment:
            return CGSize(width: UIScreen.main.bounds.width, height: 90)
        }
    }
}

protocol WeatherCardCell: class {
    func flipCard()
}

protocol HomeBGColorControlDelegate {
    func updateThemeColor(_ color: UIColor)
}

class HomeViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var backgroundColorView: UIView!
    @IBOutlet fileprivate weak var commentContainer: UIView!
    @IBOutlet fileprivate weak var commentBtn: UIButton!
    
    fileprivate let homeDataController: HomeDataController = HomeDataController()
    fileprivate let homeCellDatasource: [HomeCellType] = [.bestCommentCollection, .weatherCardCollection]
    fileprivate var commentViewController: HomeCommentViewController!
    fileprivate var notification: NotificationCenter = NotificationCenter.default
    
    private var homeData: HomeData? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
        prepareCells()
        reloadData()
    }
    
    fileprivate func prepareCells() {
        collectionView.register(cellTypes: homeCellDatasource)
    }
    
    fileprivate func prepareObservers() {
        notification.addObserver(self, selector: #selector(reloadOnLogin), name: .LoginSuccess, object: nil)
    }
    
    deinit {
        notification.removeObserver(self, name: .LoginSuccess, object: nil)
    }
}

extension HomeViewController {
    @objc private func reloadOnLogin() {
        reloadData()
    }
    
    private func reloadData(completion: (() -> Void)? = nil) {
        let location: RWLocation = RWLocationManager.shared.currentLocation
        homeDataController.requestData(for: location) { [weak self] homeData in
            self?.homeData = homeData
        }
    }
}

extension HomeViewController {
    func updateView() {
        commentContainer.layer.applySketchShadow(color: UIColor.shadowColor30, alpha: 1, x: 0, y: -2, blur: 9, spread: 0)
        collectionView.reloadData()
    }
}

extension HomeViewController: HomeBGColorControlDelegate {
    func updateThemeColor(_ color: UIColor) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.backgroundColorView.backgroundColor = color
        }
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
            if let cardDatasource = homeData?.homeCards {
                weatherCollectionCell.cardDatasource = cardDatasource
            }
            weatherCollectionCell.selectedMenu = .today
            weatherCollectionCell.bgControlDelegate = self
        } else if let bestCommentCollectionCell = cell as? HomeBestCommentCollectionCell {
            bestCommentCollectionCell.comments = homeData?.bestComments ?? []
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
    
    func collectionView(_ collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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
