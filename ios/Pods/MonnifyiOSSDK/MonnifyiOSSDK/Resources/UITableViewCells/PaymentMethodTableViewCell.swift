//
//  PaymentMethodTableViewCell.swift
//  Monnify
//
//  Created by Kanyinsola on 25/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var paymentMethod: PaymentMethodViewModel! {
        didSet {
            iconImageView.image = paymentMethod.icon
            titleLabel.text = paymentMethod.title
            //subtitleLabel.text = paymentMethod.subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedBackground
    }
}
