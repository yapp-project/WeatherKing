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
    case weatherLifeCard
    case weatherWeekCard
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
        case .weatherLifeCard:
            return "HomeWeatherLifeCardCell"
        case .weatherWeekCard:
            return "HomeWeatherWeekCardCell"
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
        case .weatherTempCard, .weatherStatusCard, .weatherDustCard, .weatherLifeCard, .weatherWeekCard:
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
    @IBOutlet fileprivate weak var refreshControl: HomeRefreshControl!
    @IBOutlet fileprivate weak var commentView: UIView!
    @IBOutlet fileprivate weak var commentViewTop: NSLayoutConstraint!
    @IBOutlet fileprivate weak var commentViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var commentHeaderView: UIView!
    @IBOutlet fileprivate weak var commentHeaderTempLabel: UILabel!
    @IBOutlet fileprivate weak var commentHeaderStatusLabel: UILabel!
    @IBOutlet fileprivate weak var bottomView: UIView!
    
    fileprivate let homeDataController: HomeDataController = HomeDataController()
    fileprivate let homeCellDatasource: [HomeCellType] = [.bestCommentCollection, .weatherCardCollection]
    fileprivate var commentViewController: HomeCommentViewController?
    fileprivate var notification: NotificationCenter = NotificationCenter.default
    
    var isCommentOpened: Bool = false
    
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
        
        commentViewHeight.constant = view.bounds.height
    }
    
    fileprivate func prepareCells() {
        collectionView.register(cellTypes: homeCellDatasource)
    }
    
    fileprivate func prepareObservers() {
        notification.addObserver(self, selector: #selector(reloadOnEvent), name: .LoginSuccess, object: nil)
        notification.addObserver(self, selector: #selector(handleReachabilityChange), name: .reachabilityChanged, object: nil)
    }
    
    deinit {
        notification.removeObserver(self, name: .LoginSuccess, object: nil)
    }
}

extension HomeViewController {
    @objc private func handleReachabilityChange() {
        guard RWNetworkManager.shared.isConnected, homeData == nil else {
            return
        }
        reloadData()
    }
    
    @objc private func reloadOnEvent() {
        reloadData()
    }
    
    private func reloadData(completion: (() -> Void)? = nil) {
        let location: RWLocation = RWLocationManager.shared.currentLocation
        RootViewController.shared().startLoading()
        RWLocationManager.shared.updateLocation()
        homeDataController.requestData(for: location) { [weak self] homeData in
            RootViewController.shared().stopLoading()
            self?.homeData = homeData
            completion?()
        }
    }
}

extension HomeViewController {
    func updateView() {
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

// MARK: IBActions
extension HomeViewController {
    @IBAction func onRefreshToggled(_ sender: HomeRefreshControl) {
        reloadData {
            sender.stopRefreshing()
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl?.scrollRefeshControl(scrollView)
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
            if homeData?.bestComments.isEmpty ?? true {
                bestCommentCollectionCell.comments = [HomeData.defaultComment]
            } else {
                bestCommentCollectionCell.comments = homeData?.bestComments ?? []
            }
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

extension HomeViewController {
    func openCommentView(completion: (() -> Void)? = nil) {
        let todayInfo = homeData?.homeCards[.today]?.first as? RWHomeTempCard
        commentHeaderView.backgroundColor = todayInfo?.mainColor
        commentHeaderTempLabel.text = todayInfo?.currentTemp.tempFormat
        commentHeaderStatusLabel.text = todayInfo?.type.title ?? ""
        
        view.bringSubviewToFront(commentHeaderView)
        view.bringSubviewToFront(commentView)
        view.bringSubviewToFront(bottomView)
        let animations: () -> Void = { [weak self] in
            guard let `self` = self else {
                return
            }
            RootViewController.shared().navigationView.alpha = 0.0
            self.commentViewTop.constant = self.view.bounds.height - 140
            self.commentViewHeight.constant = self.view.bounds.height - 140
            self.commentHeaderView.alpha = 1.0
            self.bottomView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: animations) { [weak self] _ in
            self?.commentViewController?.isOpened = true
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.commentHeaderTempLabel.alpha = 1.0
                self?.commentHeaderStatusLabel.alpha = 1.0
                }, completion: { _ in
                    completion?()
            })
        }
        isCommentOpened = true
    }
    
    func closeCommentView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            RootViewController.shared().navigationView.alpha = 1.0
            self?.commentViewTop.constant = 50
            self?.commentHeaderView.alpha = 0.0
            self?.commentHeaderTempLabel.alpha = 0.0
            self?.commentHeaderStatusLabel.alpha = 0.0
            self?.bottomView.alpha = 1.0
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let `self` = self else {
                    return
                }
                self.commentViewController?.isOpened = false
                self.commentViewHeight.constant = self.view.bounds.height
                self.view.sendSubviewToBack(self.commentHeaderView)
                completion?()
        })
        isCommentOpened = false
    }
    
    @IBAction func onCommentViewTapped(_ sender: UIGestureRecognizer) {
        let touchLocationY: CGFloat = sender.location(in: view).y

        switch sender.state {
        case .changed:
            commentViewTop.constant = min(view.bounds.height - 140, view.bounds.height - touchLocationY + 30)
        case .ended:
            
            if !isCommentOpened {
                if touchLocationY < (view.bounds.height * 3) / 4 {
                    openCommentView()
                } else {
                    closeCommentView()
                }
            } else {
                if touchLocationY < view.bounds.height / 4 {
                    openCommentView()
                } else {
                    closeCommentView()
                }
            }
        default:
            break
        }
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !isCommentOpened && commentView.frame.contains(touch.location(in: view)) {
            return true
        }
        
        if let commentViewController = commentViewController {
            if commentView.frame.contains(touch.location(in: view)) {
                var shouldReceiveTouch = true
                commentViewController.viewsToIgnoreRootGesture.forEach {
                    if $0.frame.contains(touch.location(in: commentViewController.view)) {
                        shouldReceiveTouch = false
                    }
                }
                if commentViewController.gestureHandleView.frame.contains(touch.location(in: commentViewController.view)) {
                    shouldReceiveTouch = true
                }
                return shouldReceiveTouch
            } else {
                return false
            }
        }
        
        return false
    }
}
