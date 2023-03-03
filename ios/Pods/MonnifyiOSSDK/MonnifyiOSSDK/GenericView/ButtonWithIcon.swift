//
//  ButtonWithIcon.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 13/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

class ButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 2, left: (bounds.width), bottom: 2, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
