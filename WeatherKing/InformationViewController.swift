//
//  InformationViewController.swift
//  WeatherKing
//
//  Created by yoo on 2019. 5. 23..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var textview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textview.isEditable = false
    }
}

extension InformationViewController {
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
