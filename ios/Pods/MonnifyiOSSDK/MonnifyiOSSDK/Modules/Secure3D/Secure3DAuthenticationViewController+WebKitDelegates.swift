//
//  Secure3DAuthenticationViewController+WebKitDelegates.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit
import WebKit

extension Secure3DAuthenticationViewController: WKUIDelegate {
    
}

extension Secure3DAuthenticationViewController: WKNavigationDelegate {
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        //
        Logger.log("webViewWebContentProcessDidTerminate was called. \(webView.url?.absoluteString ?? "")")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dismissLoading()
        // MARK: TODO : HANDLE PAGE LOADING FAILURE.
        Logger.log("ERROR OCCURRED \(error)")
    }
    
    func webView(_ webView: WKWebView, didFinish na1258vigation: WKNavigation!) {
        
        Logger.log("didFinish navigation: isLoading \(webView.isLoading)")
        
        webView.frame.size.height = 1
        webView.frame.size = webView.scrollView.contentSize
        dismissLoading()
        
        let url = webView.url?.absoluteString
        
        if url == secure3DSData.callBackUrl {
            
            // IPG Integration requires authorizing firing authorize secure 3d api.
            if secure3DSData.getProvider() == .ipg {
                // found call back url for interswitch.
                // authorize secure 3d.
                showLoading(text: "Please wait while we confirm your payment status.")
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
                    self.presenter.authorizeSecure3d()
                }
            }
        }
        
        Logger.log("URL was loaded in : \(webView.url?.absoluteString ?? "EMPTY")")
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
}
