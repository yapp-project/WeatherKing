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
        case .weatherTempCard, .weatherStatusCard, .weatherDustCard, .weatherLifeCard:
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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    fileprivate var panGesture = UIPanGestureRecognizer()
    fileprivate let homeDataController: HomeDataController = HomeDataController()
    fileprivate let homeCellDatasource: [HomeCellType] = [.bestCommentCollection, .weatherCardCollection]
    fileprivate var commentViewController: HomeCommentViewController!
    fileprivate var commentHeaderView: CommentHeaderView!
    fileprivate var notification: NotificationCenter = NotificationCenter.default
    fileprivate var screenHeight: CGFloat = 0
    fileprivate var containerPoint: CGPoint = CGPoint.zero
    fileprivate var bottomArea:CGFloat = 0
    fileprivate var rootViewController: RootViewController?
    
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
        rootViewController = self.parent?.parent as? RootViewController
        screenHeight = UIScreen.main.bounds.height
        if let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            self.bottomArea = bottom
        }
        containerViewTopConstraint.constant = screenHeight - 54 - bottomArea
        bottomHeightConstraint.constant = bottomArea
        containerViewHeightConstraint.constant = screenHeight
        containerPoint = self.containerView.frame.origin
        
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
        collectionView.reloadData()
    }
    
    @objc func swipeContainer(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self.commentHeaderView)
        let translationY = sender.translation(in: containerView).y  // 팬제스쳐의 좌표
        if abs(velocity.y) > abs(velocity.x) {
            if sender.state == .ended {
                if translationY <= 0 {  // up
                    rootViewController?.homeNavigationBarViewController.view.isHidden = true
                    self.commentViewController.weatherViewHeightConstraint.constant = 64
                    self.commentViewController.setComment()
//                    self.commentViewController.turnTimer(true)
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
                        self.commentHeaderView.isHiddenSubViews = false
                        self.commentViewController.view.backgroundColor = UIColor.purpleishBlue
                        self.containerView.frame.origin = CGPoint(x: self.containerView.frame.origin.x, y: self.view.frame.origin.y)
                        }, completion: { [unowned self] _ in
                            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
                                self.commentViewController.weatherView.alpha = 1
                            })
                            self.commentViewController.commentCollectionView.layer.masksToBounds = true
                            
                    })
                }
                else {  // down
                    rootViewController?.homeNavigationBarViewController.view.isHidden = false
                    self.commentViewController.commentCollectionView.layer.masksToBounds = false
//                    self.commentViewController.turnTimer(false)
                    UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: { [unowned self] in
                        self.commentHeaderView.isHiddenSubViews = true
                        self.commentViewController.weatherView.alpha = 0
                        self.commentViewController.view.backgroundColor = UIColor.white
                        if self.bottomArea != 0 {
                            self.containerView.frame.origin = CGPoint(x: self.containerPoint.x, y: self.containerPoint.y + 64)
                        }
                        else {
                            self.containerView.frame.origin = CGPoint(x: self.containerPoint.x, y: self.containerPoint.y)
                        }
                        }, completion: { [unowned self] _ in
                            self.commentViewController.weatherViewHeightConstraint.constant = 0
                            
                    })
                    
                }
            }
        }
        
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
            commentViewController.commentDelegate = self
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

extension HomeViewController: CommentDelegate {
    func getHeader(header: CommentHeaderView) {
        commentHeaderView = header
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeContainer(_:)))
        commentHeaderView.addGestureRecognizer(panGesture)
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
