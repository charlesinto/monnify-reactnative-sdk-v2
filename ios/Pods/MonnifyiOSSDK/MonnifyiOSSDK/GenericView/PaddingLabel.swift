//
//  PaddingLabel.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 01/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 15.0
    @IBInspectable var rightInset: CGFloat = 15.0

    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
