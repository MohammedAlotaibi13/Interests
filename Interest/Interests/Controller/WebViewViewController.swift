//
//  WebViewViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 3/15/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
// MARK: - WebViewViewController
class WebViewViewController: UIViewController , UIWebViewDelegate  {
    // MARK: Outlests
    @IBOutlet weak var nwesWebView: UIWebView!
    //  @IBOutlet weak var seconView: UIView!
    @IBOutlet weak var activityIndicater: UIActivityIndicatorView!
    let internet = Reachability()!
    var url:String?
    // MARK: Life Cycle :
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internet.whenReachable = { _ in
            DispatchQueue.main.async {
                self.uploadUrl()
            }
        }
        internet.whenUnreachable = { _ in
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internt Connection", in: self)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(checkingInternet), name: .reachabilityChanged, object: internet)
        do{
            try internet.startNotifier()
        } catch {
            print("error")
        }
    }
    
    // MARK : functions
    
    @objc func checkingInternet(_ notification: Notification){
        let reachInternet = notification.object as! Reachability
        if reachInternet.isReachable {
            print("Internet is on")
        } else {
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection", in: self)
                self.activityIndicater.stopAnimating()
            }
        }
    }
    
    
    func uploadUrl(){
        
        self.activityIndicater.startAnimating()
        nwesWebView.loadRequest(URLRequest(url: URL(string: url!)!))
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityIndicater.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activityIndicater.stopAnimating()
    }
}
