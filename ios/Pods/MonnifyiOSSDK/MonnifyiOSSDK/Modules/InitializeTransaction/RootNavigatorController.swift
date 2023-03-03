//
//  RootNavigatorController.swift
//  MonnifyiOSSDK
//
//  Created by Kanyinsola on 18/11/2019.
//  Copyright © 2019 Monnify. All rights reserved.
//

import UIKit

class RootNavigatorController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationController?.delegate = self
    }
}

extension RootNavigatorController : UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        completeTransaction()
        Logger.log("presentationControllerDidDismiss was called in RootNavigatorController")
    }
}
