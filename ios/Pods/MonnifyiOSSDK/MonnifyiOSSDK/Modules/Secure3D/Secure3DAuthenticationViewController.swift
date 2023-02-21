//
//  Secure3DAuthenticationViewController.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit
import WebKit

class Secure3DAuthenticationViewController: BaseViewController {
    
    var secure3DSData: Secure3dData!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    
    private var progressObservation: NSKeyValueObservation? = nil
    
    var presenter: Secure3DPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addCancelButton()
        prepareWebView()
    }
    
    private func prepareWebView() {
        
        title = StringLiterals.Secure3D
        
        presenter = Secure3DPresenter(view: self,
                                      apiService: ApiService.shared)
        
        webKitView.uiDelegate = self
        webKitView.navigationDelegate = self
        webKitView.scrollView.isScrollEnabled = true
        
        let javaScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let userScript = WKUserScript(source: javaScript,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: false)
        
        let wkController = WKUserContentController()
        wkController.addUserScript(userScript)
        
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = wkController
        
        progressObservation = webKitView.observe(\WKWebView.estimatedProgress , options: [.new]) { [weak self] _, _ in
            
            guard let self = self else { return }

            self.progressView.progress = Float(self.webKitView.estimatedProgress)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadWebView()
        presenter.startListening()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.stopListening()
    }
    
    private func loadWebView() {
        
        guard let url = URL(string: secure3DSData.redirectUrl) else {
            
            showAlertDialog(title: StringLiterals.ErrorOccured,
                            message: StringLiterals.SystemError)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = secure3DSData.method
        urlRequest.addValue("application/x-www-form-urlencoded",
                            forHTTPHeaderField: "Content-Type")

        urlRequest.httpBody = secure3DSData.getPostBody()

        showLoading(text: "Please wait while we take you to authorize your transaction.")
        webKitView.load(urlRequest)
    }
    
    private func addCancelButton() {
        
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(userPressedCancel))
        
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func userPressedCancel() {
        navigationController?.popViewController(animated: true)
    }
}
