//
//  UIView+Gradient.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 02/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

extension UIView {

    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
}
