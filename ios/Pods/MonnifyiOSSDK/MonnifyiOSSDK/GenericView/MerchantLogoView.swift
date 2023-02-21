//
//  MerchantLogoView.swift
//  MonnifyiOSSDK
//
//  Created by Nathaniel Ogunye on 06/09/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

@IBDesignable
class MerchantLogoView: UIImageView {
    
    private var merchantLogoUrl: String?
    private var merchantName: String?
    
    
    lazy var logoUIImageView: UIImage? = {
        let imageView = UIImageView()
        
        let uiImage = (merchantLogoUrl == nil || merchantLogoUrl?.isEmpty ?? true) ? imageFromText(merchantName ?? "") : imageFromByte(merchantLogoUrl ?? "")
        
        
        return uiImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadImage(url merchantLogoUrl: String?, name merchantName: String?) -> Void {
        self.merchantLogoUrl = merchantLogoUrl
        self.merchantName = merchantName
        super.image = logoUIImageView;
    }

    
    private func imageFromByte(_ url: String) -> UIImage? {
        return UIImage.imageFromBase64(url)
    }
    
    private func imageFromText(_ name: String) -> UIImage? {
        let label = UILabel(frame: .zero);
        label.text = name.prefix(1).capitalized
        label.font = UIFont(name: "Inter-Bold", size: 16)
        label.textColor = .white
        label.sizeToFit()
        
        super.contentMode = .center
        
        return UIImage.imageFromLabel(label: label)
    }
}
