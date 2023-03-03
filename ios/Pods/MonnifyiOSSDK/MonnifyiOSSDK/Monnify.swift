//
//  Monnify.swift
//  Monnify
//
//  Created by Kanyinsola on 28/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit.UIViewController
import EasyTipView

public class Monnify : NSObject {
    
    public static let shared = Monnify()
    
    private override init(){
        super.init()
        UIFont.registerFontsIfNeeded()
        
        initializeTooltipView()
        
//        do {
//            try UIFont.register(path: "", fileNameString: "Inter-ExtraBold", type: ".ttf")}
//        catch {
//            print("Error loading font \(error)")
//        }
//        for family in UIFont.familyNames.sorted() {
//            //let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family)")
//        }
//
//        print(getAllPListFrom())
        
       
    }
    
    func getAllPListFrom()->[URL] {
        let bundle = Bundle(for: Monnify.self)

        guard let fURL = bundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil) else { return [] }
        return fURL
    }
    
    private weak var presentingViewController: UIViewController?
    private weak var presentedViewController: UIViewController?

    private var applicationMode: ApplicationMode?
    private var apiKey: String?
    private var contractCode: String?
    private var completionCallback: MonnifySuccessCompletion?
    
    // Set Once when transaction is initialized
    private var transactionParameters: TransactionParameters!
    internal var metadata: TransactionMetaData!
    internal var transactionResult = TransactionResult()
    internal var loggingEnabed: Bool = false
    
    var environment : Environment {
        if applicationMode == ApplicationMode.live {
            return .prod_live
        } else {
            return .prod_sandbox
        }
    }

    public func setApplicationMode(applicationMode : ApplicationMode) {
        self.applicationMode = applicationMode
    }
    
    public func setLoggingEnabled(enabled: Bool) {
        self.loggingEnabed = enabled
    }
    
    public func setApiKey(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func setContractCode(contractCode: String) {
        self.contractCode = contractCode
    }

    func getApplicationMode() -> ApplicationMode? {
        return applicationMode
    }
    
    func getContractCode() -> String? {
        return contractCode
    }
    
    func getApiKey() -> String? {
        return apiKey
    }
    
    func getTransactionParameters() -> TransactionParameters {
        return transactionParameters
    }
    
    private func initializeTooltipView(){
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Inter-Bold", size: 9)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hex: "273142")
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.right

        EasyTipView.globalPreferences = preferences
    }
    
    public func initializePayment(withTransactionParameters parameters : TransactionParameters,
                                presentingViewController viewController: UIViewController,
                                onTransactionSuccessful successCompletion: @escaping MonnifySuccessCompletion) {
        
        Logger.log("Parameters \(parameters)")
        
        resetBeforeTransactionInitialization()
        
        self.transactionParameters = parameters
        self.presentingViewController = viewController
        self.completionCallback = successCompletion
        
        presentedViewController = viewController.viewController(type: RootNavigatorController.self)
        viewController.present(presentedViewController!, animated: true, completion: nil)
    }
    
    func completeTransaction() {
        presentedViewController?.dismiss(animated: true, completion: {
            self.completionCallback?(self.transactionResult)
            Logger.log("PresentedViewController completion was called")
        })
    }
    
    private func resetBeforeTransactionInitialization() {
        transactionResult = TransactionResult()
        metadata = nil
    }
}
