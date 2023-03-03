//
//  GradientButton.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 02/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//


import UIKit

public typealias LBCallback = (() -> Void)?


@IBDesignable
public class GradientButton: UIButton {
    
    
    
    public var isLoading: Bool = false
    /**
     The flag that indicate if the shadow is added to prevent duplicate drawing.
     */
    public var shadowAdded: Bool = false
    
    private var loaderWorkItem: DispatchWorkItem?
    // MARK: - Package-protected variables
    /**
     The loading indicator used with the button.
     */
    open var indicator: UIView & IndicatorProtocol = UIActivityIndicatorView()
    
    public override class var layerClass: AnyClass         { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }

    @IBInspectable public var startColor: UIColor = .white { didSet { updateColors() } }
    @IBInspectable public var endColor: UIColor = .red     { didSet { updateColors() } }

    // expose startPoint and endPoint to IB

    @IBInspectable public var startPoint: CGPoint {
        get { gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }

    @IBInspectable public var endPoint: CGPoint {
        get { gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }

    // while we're at it, let's expose a few more layer properties so we can easily adjust them in IB

    @IBInspectable public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

//    @IBInspectable public override var borderWidth: CGFloat {
//        get { layer.borderWidth }
//        set { layer.borderWidth = newValue }
//    }

    @IBInspectable public var borderColor: UIColor? {
        get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }

    // init methods

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateColors()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColors()
    }
    
    open func showLoader(userInteraction: Bool, _ completion: LBCallback = nil) {
          showLoader([titleLabel, imageView], userInteraction: userInteraction, completion)
      }
      /**
       Show a loader inside the button with image.
       
       - Parameter userInteraction: Enable user interaction while showing the loader.
       */
      open func showLoaderWithImage(userInteraction: Bool = false) {
          showLoader([self.titleLabel], userInteraction: userInteraction)
      }
      /**
       Display the loader inside the button.
       
       - Parameter viewsToBeHidden: The views such as titleLabel, imageViewto be hidden while showing loading indicator.
       - Parameter userInteraction: Enable the user interaction while displaying the loader.
       - Parameter completion:      The completion handler.
      */
      open func showLoader(_ viewsToBeHidden: [UIView?], userInteraction: Bool = false, _ completion: LBCallback = nil) {
          guard !self.subviews.contains(indicator) else { return }
          // Set up loading indicator and update loading state
          isLoading = true
          self.isUserInteractionEnabled = userInteraction
          indicator.radius = min(0.7*self.frame.height/2, indicator.radius)
          indicator.alpha = 0.0
          self.addSubview(self.indicator)
          // Clean up
          loaderWorkItem?.cancel()
          loaderWorkItem = nil
          // Create a new work item
          loaderWorkItem = DispatchWorkItem { [weak self] in
              guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
              UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
                  viewsToBeHidden.forEach { view in
                      view?.alpha = 0.0
                  }
                  self.indicator.alpha = 1.0
              }) { _ in
                  guard !item.isCancelled else { return }
                  self.isLoading ? self.indicator.startAnimating() : self.hideLoader()
                  completion?()
              }
          }
          loaderWorkItem?.perform()
      }
      /**
       Hide the loader displayed.
       
       - Parameter completion: The completion handler.
       */
      open func hideLoader(_ completion: LBCallback = nil) {
          DispatchQueue.main.async { [weak self] in
              guard let self = self else { return }
              guard self.subviews.contains(self.indicator) else { return }
              // Update loading state
              self.isLoading = false
              self.isUserInteractionEnabled = true
              self.indicator.stopAnimating()
              // Clean up
              self.indicator.removeFromSuperview()
              self.loaderWorkItem?.cancel()
              self.loaderWorkItem = nil
              // Create a new work item
              self.loaderWorkItem = DispatchWorkItem { [weak self] in
                  guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
                  UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
                      self.titleLabel?.alpha = 1.0
                      self.imageView?.alpha = 1.0
                  }) { _ in
                      guard !item.isCancelled else { return }
                      completion?()
                  }
              }
              self.loaderWorkItem?.perform()
          }
      }
}

private extension GradientButton {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    

    
    public override func layoutSubviews() {
           super.layoutSubviews()
           indicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
       }
    
}

// MARK: - UIActivityIndicatorView
extension UIActivityIndicatorView: IndicatorProtocol {
    public var radius: CGFloat {
        get {
            return self.frame.width/2
        }
        set {
            self.frame.size = CGSize(width: 2*newValue, height: 2*newValue)
            self.setNeedsDisplay()
        }
    }
    
    public var color: UIColor {
        get {
            return self.tintColor
        }
        set {
            let _ = CIColor(color: newValue)
//            #if os(iOS)
//            self.style = newValue.RGBtoCMYK(red: ciColor.red, green: ciColor.green, blue: ciColor.blue).key > 0.5 ? .gray : .white
//            #endif
//            self.tintColor = newValue
        }
    }
    // unused
    public func setupAnimation(in layer: CALayer, size: CGSize) {}
}


public protocol IndicatorProtocol {
    /**
     The radius of the indicator.
     */
    var radius: CGFloat { get set }
    /**
     The primary color of the indicator.
     */
    var color: UIColor { get set }
    /**
     Current status of animation, read-only.
     */
    var isAnimating: Bool { get }
    /**
     Start animating.
     */
    func startAnimating()
    /**
     Stop animating and remove layer.
     */
    func stopAnimating()
    /**
     Set up the animation of the indicator.
     
     - Parameter layer: The layer to present animation.
     - Parameter size:  The size of the animation.
     */
    func setupAnimation(in layer: CALayer, size: CGSize)
}

open class LBIndicator: UIView, IndicatorProtocol {
    open var isAnimating: Bool = false
    open var radius: CGFloat = 18.0
    open var color: UIColor = .lightGray
    
    public convenience init(radius: CGFloat = 18.0, color: UIColor = .gray) {
        self.init()
        self.radius = radius
        self.color = color
    }
    
    open func startAnimating() {
        guard !isAnimating else { return }
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation(in: self.layer, size: CGSize(width: 2*radius, height: 2*radius))
    }
    
    open func stopAnimating() {
        guard isAnimating else { return }
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    open func setupAnimation(in layer: CALayer, size: CGSize) {
        fatalError("Need to be implemented")
    }
}
