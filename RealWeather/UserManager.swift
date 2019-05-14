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
}

class LoginManager: NSObject {
    static let shared = LoginManager()
    
    private let notification = NotificationCenter.default
    public var isLoggedIn: Bool = false {
        didSet {
            guard oldValue != isLoggedIn else {
                return
            }
            if isLoggedIn {
                notification.post(name: .LoginSuccess, object: nil)
            } else {
                notification.post(name: .LogoutSuccess, object: nil)
            }
        }
    }
    
    public var loginMethod: SignUpMethod? {
        didSet {
            if let loginMethod = loginMethod, oldValue != loginMethod {
                UserDefaultsManager.LastLoginMethod.set(loginMethod.rawValue)
            }
        }
    }
    
    override init() {
        super.init()
        restoreLastLoginMethod()
        prepareObservers()
    }
    
    private func restoreLastLoginMethod() {
        let lastLoginMethod: Int = UserDefaultsManager.LastLoginMethod.get()
        loginMethod = SignUpMethod(rawValue: lastLoginMethod)
        restoreLoginStatus()
    }
    
    private func prepareObservers() {
        notification.addObserver(self, selector: #selector(kakaoSessionDidChange(with:)), name: .KOSessionDidChange, object: nil)
        notification.addObserver(self, selector: #selector(facebookTokenDidChange(with:)), name: .FBSDKAccessTokenDidChange, object: nil)
    }
}

// MARK: Login
extension LoginManager {
    public func restoreLoginStatus() {
        guard let method = loginMethod else {
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
            loginMethod = .kakao
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    private func restoreFacebookSession() {
        if FBSDKAccessToken.currentAccessTokenIsActive() {
            loginMethod = .facebook
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    private func restoreGoogleSession() {
        GIDSignIn.sharedInstance()?.signInSilently()
    }
}

// MARK: Logout
extension LoginManager {
    public func logout() {
        guard let method = loginMethod else {
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
            guard result, error != nil else {
                return
            }
            self?.loginMethod = nil
            self?.isLoggedIn = false
        }
    }
    
    private func logoutFacebookSession() {
        FBSDKLoginManager().logOut()
        isLoggedIn = false
        loginMethod = nil
    }
    
    private func logoutGoogleSession() {
        GIDSignIn.sharedInstance()?.signOut()
        isLoggedIn = false
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
                self?.loginMethod = .kakao
                self?.isLoggedIn = true
            } else {
                self?.isLoggedIn = false
            }
        }
    }
    
    private func presentFacebookSignUp(on viewController: UIViewController) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: viewController) { [weak self] result, error in
            guard let result = result else {
                self?.isLoggedIn = false
                return
            }
            self?.loginMethod = .facebook
            self?.isLoggedIn = true
        }
        
    }
    
    private func presentGoogleSignUp(on viewController: UIViewController) {
        if let viewController = viewController as? GIDSignInUIDelegate {
            GIDSignIn.sharedInstance()?.uiDelegate = viewController
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
}

// MARK: Unlink
extension LoginManager {
    public func unlinkAccount() {
        guard let method = loginMethod else {
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
        isLoggedIn = false
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        loginMethod = .google
        isLoggedIn = true
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
