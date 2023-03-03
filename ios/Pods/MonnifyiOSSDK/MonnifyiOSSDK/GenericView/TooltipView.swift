//
//  TooltipView.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 21/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation
import UIKit

class TooltipView: UIView {
    enum ToolTipPosition: Int {
         case left
         case right
         case middle
     }
    
    var roundRect:CGRect!
    let toolTipWidth : CGFloat = 20.0
    let toolTipHeight : CGFloat = 12.0
    let tipOffset : CGFloat = 20.0
    var tipPosition : ToolTipPosition = .left
  
    convenience init(frame: CGRect, text : String, tipPos: ToolTipPosition){
        self.init(frame: frame)
        self.tipPosition = tipPos
        
        roundRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height - toolTipHeight)
      //  let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 5.0)
        
    }
    
    
    override func draw(_ rect: CGRect) {
       super.draw(rect)
       drawToolTip(rect)
    }
    
    func createTipPath() -> UIBezierPath{
        let tooltipRect = CGRect(x: roundRect.maxX, y: roundRect.maxY, width: toolTipWidth, height: toolTipHeight)
       let trianglePath = UIBezierPath()
       trianglePath.move(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
       trianglePath.addLine(to: CGPoint(x: tooltipRect.maxX, y: tooltipRect.minY))
       trianglePath.addLine(to: CGPoint(x: tooltipRect.midX, y: tooltipRect.maxY))
       trianglePath.addLine(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
       trianglePath.close()
       return trianglePath
    }
    
    func drawToolTip(_ rect : CGRect){
       roundRect = CGRect(x: rect.maxX, y: rect.minY, width: rect.width, height: rect.height - toolTipHeight)
       let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 5.0)
       let trianglePath = createTipPath()
       roundRectBez.append(trianglePath)
       let shape = createShapeLayer(roundRectBez.cgPath)
       self.layer.insertSublayer(shape, at: 0)
    }
    
    func createShapeLayer(_ path : CGPath) -> CAShapeLayer{
       let shape = CAShapeLayer()
       shape.path = path
       shape.fillColor = UIColor.darkGray.cgColor
       shape.shadowColor = UIColor.black.withAlphaComponent(0.60).cgColor
       shape.shadowOffset = CGSize(width: 0, height: 2)
       shape.shadowRadius = 5.0
       shape.shadowOpacity = 0.8
       return shape
    }
    
}
