//
//  InformationViewController.swift
//  RealWeather
//
//  Created by yoo on 2019. 5. 23..
//  Copyright © 2019년 yapp. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://docs.google.com/spreadsheets/d/1h-uogVD5AXyOrTxkjmllUoa_HBIVWvZM/edit#gid=1851164093")
        let requestObj = URLRequest(url: url!)
        webview.loadRequest(requestObj)
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
