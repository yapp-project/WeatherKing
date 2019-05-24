//
//  LoginManager.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

extension Notification.Name {
    public static let LoginSuccess = Notification.Name("LoginSuccess")
    public static let LogoutSuccess = Notification.Name("LogoutSuccess")
    public static let UserRegistrationNeeded = Notification.Name("UserRegistrationNeeded")
}

class LoginManager: NSObject {
    static let shared = LoginManager()
    
    private let requestor: LoginDataController = LoginDataController()
    private let notification = NotificationCenter.default
    
    public var isLoggedIn: Bool {
        return user != nil
    }
    
    public var user: RWUser? {
        didSet {
            if let loginMethod = user?.loginMethod {
                UserDefaultsManager.LastLoginMethod.set(loginMethod.rawValue)
            }
            
            if user != nil {
                notification.post(name: .LoginSuccess, object: nil)
            } else if oldValue != nil {
                notification.post(name: .LogoutSuccess, object: nil)
            }
        }
    }
    
    override init() {
        super.init()
        restoreLoginStatus()
        prepareObservers()
    }
    
    private func restoreLastLoginMethod() -> SignUpMethod? {
        
        let lastLoginMethod: Int = UserDefaultsManager.LastLoginMethod.get()
        return SignUpMethod(rawValue: lastLoginMethod)
    }
    
    private func invalidateUserLogin() {
        user = nil
    }
    
    private func prepareObservers() {
        notification.addObserver(self, selector: #selector(kakaoSessionDidChange(with:)), name: .KOSessionDidChange, object: nil)
        notification.addObserver(self, selector: #selector(facebookTokenDidChange(with:)), name: .FBSDKAccessTokenDidChange, object: nil)
    }
}

extension LoginManager {
    public func register(user: RWUser, completion: @escaping (Bool) -> Void) {
        requestor.register(user: user) { [weak self] result in
            guard let result = result, result else {
                completion(false)
                return
            }
            self?.user = user
            completion(true)
        }
    }
}

// MARK: Login
extension LoginManager {
    public func restoreLoginStatus() {
        guard let method = restoreLastLoginMethod() else {
            return
        }
        
        switch method {
        case .kakao:
            restoreKakaoSession()
        case .facebook:
            restoreFacebookSession()
        case .google:
            restoreGoogleSession()
        }
    }
    
    private func restoreKakaoSession() {
        if KOSession.shared()?.isOpen() ?? false {
            KOSessionTask.userMeTask { [weak self] error, userInfo in
                guard let uniqueID = userInfo?.id, error == nil else {
                    return
                }
                let user: RWUser = RWUser(uniqueID: uniqueID + "3", loginMethod: .kakao)
                
                self?.requestor.login(user: user) { [weak self] result in
                    if result ?? false {
                        self?.user = user
                    } else {
                        self?.notification.post(name: .UserRegistrationNeeded, object: user)
                    }
                }
            }
        }
    }
    private func restoreFacebookSession() {
        if FBSDKAccessToken.currentAccessTokenIsActive() {
            user = RWUser(uniqueID: "", loginMethod: .facebook)
        }
    }
    
    private func restoreGoogleSession() {
        GIDSignIn.sharedInstance()?.signInSilently()
    }
}

// MARK: Logout
extension LoginManager {
    public func logout() {
        guard let method = user?.loginMethod else {
            return
        }
        
        switch method {
        case .kakao:
            logoutKakaoSession()
        case .facebook:
            logoutFacebookSession()
        case .google:
            logoutGoogleSession()
        }
    }
    
    private func logoutKakaoSession() {
        KOSession.shared()?.logoutAndClose { [weak self] result, error in
            guard result, error == nil else {
                return
            }
            if self?.user?.loginMethod == SignUpMethod.kakao {
                self?.invalidateUserLogin()
            }
        }
    }
    
    private func logoutFacebookSession() {
        FBSDKLoginManager().logOut()
        if user?.loginMethod == SignUpMethod.facebook {
            invalidateUserLogin()
        }
    }
    
    private func logoutGoogleSession() {
        GIDSignIn.sharedInstance()?.signOut()
        if user?.loginMethod == SignUpMethod.google {
            invalidateUserLogin()
        }
    }
}

// MARK: SignUp
extension LoginManager {
    public func presentSignUp(on presentingVC: UIViewController, method: SignUpMethod) {
        switch method {
        case .kakao:
            presentKakaoSignUp()
        case .facebook:
            presentFacebookSignUp(on: presentingVC)
        case .google:
            presentGoogleSignUp(on: presentingVC)
        }
    }
    
    private func presentKakaoSignUp() {
        let session: KOSession = KOSession.shared()
        if session.isOpen() {
            session.close()
        }
        
        session.open { [weak self] error in
            if session.isOpen() {
                KOSessionTask.userMeTask { [weak self] error, userInfo in
                    guard let uniqueID = userInfo?.id, error == nil else {
                        return
                    }
                    let user: RWUser = RWUser(uniqueID: uniqueID, loginMethod: .kakao)
                    
                    self?.requestor.login(user: user) { [weak self] result in
                        if result ?? false {
                            self?.user = user
                        } else {
                            self?.notification.post(name: .UserRegistrationNeeded, object: user)
                        }
                    }
                }
            }
        }
    }
    
    private func presentFacebookSignUp(on viewController: UIViewController) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: [], from: viewController) { [weak self] result, error in
            guard let result = result, error == nil else {
                return
            }
            let uniqueID: String = result.token.userID
            self?.user = RWUser(uniqueID: uniqueID, loginMethod: .facebook)
        }
    }
    
    private func presentGoogleSignUp(on viewController: UIViewController) {
        if let viewController = viewController as? GIDSignInUIDelegate {
            GIDSignIn.sharedInstance()?.uiDelegate = viewController
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
}

// MARK: Unlink - 스펙 아웃, 추후 필요할 경우 구현
extension LoginManager {
    public func unlinkAccount() {
        guard let method = user?.loginMethod else {
            return
        }
        
        switch method {
        case .kakao:
            unlinkKakaoAccount(completion: nil)
        case .facebook:
            unlinkFacebookAccount()
        case .google:
            unlinkGoogleAccount()
        }
    }
    
    private func unlinkKakaoAccount(completion: ((Bool) -> Void)? = nil) {
        KOSessionTask.unlinkTask { result, error in
            completion?(result)
        }
    }
    
    private func unlinkFacebookAccount() {
        
    }
    
    private func unlinkGoogleAccount() {
        
    }
}

// MARK: Google Delegate
extension LoginManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        guard self.user?.loginMethod == SignUpMethod.facebook else {
            return
        }
        self.user = nil
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.user = RWUser(uniqueID: user.userID, loginMethod: .google)
    }
}

// MARK: Kakao Delegate
extension LoginManager {
    @objc private func kakaoSessionDidChange(with notification: NSNotification) {
        
    }
}

// MARK: Facebook Delegate
extension LoginManager {
    @objc private func facebookTokenDidChange(with notification: NSNotification) {
        // TODO: 분기 처리
        restoreFacebookSession()
    }
}
