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
        notification.addObserver(self, selector: #selector(dismissOnComplete), name: .LoginSuccess, object: nil)
        notification.addObserver(self, selector: #selector(segueToNextStep(notification:)), name: .UserRegistrationNeeded, object: nil)
    }
    
    deinit {
        notification.removeObserver(self, name: .UserRegistrationNeeded, object: nil)
        notification.removeObserver(self, name: .LoginSuccess, object: nil)
    }
}

extension SignUpViewController {
    @objc private func segueToNextStep(notification: NSNotification) {
        let isInRegistrationProcess: Bool = navigationController?.viewControllers.count ?? 0 > 1
        
        if let user = notification.object as? RWUser, isInRegistrationProcess == false {
            performSegue(withIdentifier: NickNameViewController.segueIdentifier, sender: user)
        }
    }
    
    @objc private func dismissOnComplete() {
        let isInRegistrationProcess: Bool = navigationController?.viewControllers.count ?? 0 > 1
        
        guard isInRegistrationProcess == false else {
            return
        }
        
        (presentingViewController as? RootViewController)?.removeSplashView()
        dismiss(animated: false, completion: nil)
    }
}

extension SignUpViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == NickNameViewController.segueIdentifier {
            if let vc = segue.destination as? NickNameViewController {
                vc.user = sender as? RWUser
            }
        }
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

