//
//  WebViewController.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 24/05/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://suitmedia.com/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
