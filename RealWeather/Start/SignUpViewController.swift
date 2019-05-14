//
//  SignUpViewController.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit
import GoogleSignIn

public enum SignUpMethod: Int {
    case kakao
    case facebook
    case google
}

class SignUpViewController: UIViewController {
    private let notification: NotificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareObservers()
    }
    
    private func prepareObservers() {
        notification.addObserver(self, selector: #selector(segueToNextStep), name: .LoginSuccess, object: nil)
    }
    
    deinit {
        notification.removeObserver(self, name: .LoginSuccess, object: nil)
    }
}

extension SignUpViewController {
    @objc private func segueToNextStep() {
        // TODO: API 요청, 이미 가입된 사용자의 경우 프로세스 종료
        let isSignedUpUser: Bool = false
        if isSignedUpUser {
            (presentingViewController as? RootViewController)?.removeSplashView()
            dismiss(animated: false, completion: nil)
        } else {
            performSegue(withIdentifier: NickNameViewController.segueIdentifier, sender: nil)
        }
        
    }
}

extension SignUpViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}

extension SignUpViewController {
    @IBAction func onSignUpBtnTapped(_ sender: UIButton) {
        if let signUpMethod = SignUpMethod(rawValue: sender.tag) {
            LoginManager.shared.presentSignUp(on: self, method: signUpMethod)
        }
    }
}

extension SignUpViewController: GIDSignInUIDelegate {
    
}

