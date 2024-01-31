//
//  UIView+Extensions.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import UIKit
import Foundation

extension UIView {
    
    func setHidden(_ isHidden: Bool, animated: Bool, duration: TimeInterval = 0.3) {
        if animated {
            UIView.animate(withDuration: duration) {
                self.alpha = isHidden ? 0.0 : 1.0
            } completion: { _ in
                self.isHidden = isHidden
            }
        } else {
            self.isHidden = isHidden
            self.alpha = isHidden ? 0.0 : 1.0
        }
    }
    
    func removeShadow() {
        self.layer.shadowColor = nil
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowPath = nil
    }
    
    enum Location: String {
        case top
        case bottom
        case left
        case right
        
    }
    
    func addShadow(location: Location, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 2), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -2), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -2, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 2, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func addAllSideShadow(cornerRadius:CGFloat? = 10) {
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.cornerRadius = cornerRadius ?? 10
    }
    
    func addTopShadow(radius: CGFloat = 5, color: UIColor = .black) {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: 0))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width-20, y: self.bounds.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width-20, y: self.bounds.height))
        shadowPath.close()
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = radius
    }
    
    func addDashedBorder(borderColor: UIColor) {
        let color = borderColor.resolvedColor(with: self.traitCollection).cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    
    func addBorder(color: UIColor? = .black, width: CGFloat = 1) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.resolvedColor(with: self.traitCollection).cgColor
    }
    
    func applyBorderWithColor(radius: CGFloat = 3, width: CGFloat = 1, borderColor: UIColor? = .black) {
        addBorder(color: borderColor, width: width)
        rounded(with: radius)
        self.layer.masksToBounds = false
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
    
    /// Use this to apply only some rounded corners and not all
    /// - Parameters:
    ///   - corners: mask or corners to be rounded.
    ///   - radius: value for radius to be corners.
    func roundedCorners(_ corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    /// Use this apply all rounded corners. Set nil if you want your view to be circled.
    /// - Parameter radius: corner radius you want to apply.
    func rounded(with radius: CGFloat? = nil) {
        let value: CGFloat
        if let radius {
            value = radius
        } else {
            value = min(frame.width/2, frame.height/2)
        }
        layer.cornerRadius = value
        layer.masksToBounds = true
    }
}

extension UIView {
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let viewTag = viewWithTag(Int(edge.rawValue)) {
                    viewTag.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let viewTag = UIView()
                    viewTag.tag = Int(edge.rawValue)
                    viewTag.backgroundColor = color
                    viewTag.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(viewTag)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": viewTag]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": viewTag]))
                }
            }
        }
    }
}
extension UIView {
    
    enum CornerType {
        case rounded,corner(radius: Double)
    }
    
    func cornerRaduius(cornerType: CornerType) {
        switch cornerType {
        case .rounded:
            break
        case .corner:
            break
        }
    }
}

extension UIView {
    func applyTopToBottomWhiteGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.75).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.0)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
