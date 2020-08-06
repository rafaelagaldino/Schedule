//
//  UIView+Constraints.swift
//  Schedule
//
//  Created by Rafaela Galdino on 06/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

public extension UIView {
    struct Constraint {
        public var centerX: NSLayoutConstraint? { didSet { centerX?.isActive = true } }
        public var centerY: NSLayoutConstraint? { didSet { centerY?.isActive = true } }
        public var top: NSLayoutConstraint? { didSet { top?.isActive = true } }
        public var leading: NSLayoutConstraint? { didSet { leading?.isActive = true } }
        public var trailing: NSLayoutConstraint? { didSet { trailing?.isActive = true } }
        public var left: NSLayoutConstraint? { didSet { left?.isActive = true } }
        public var right: NSLayoutConstraint? { didSet { right?.isActive = true } }
        public var bottom: NSLayoutConstraint? { didSet { bottom?.isActive = true } }
        public var width: NSLayoutConstraint? { didSet { width?.isActive = true } }
        public var height: NSLayoutConstraint? { didSet { height?.isActive = true } }
        
        func activate() {
            if let centerX = centerX { centerX.isActive = true }
            if let centerY = centerY { centerY.isActive = true }
            if let top = top { top.isActive = true }
            if let leading = leading { leading.isActive = true }
            if let trailing = trailing { trailing.isActive = true }
            if let left = left { left.isActive = true }
            if let right = right { right.isActive = true }
            if let bottom = bottom { bottom.isActive = true }
            if let width = width { width.isActive = true }
            if let height = height { height.isActive = true }
        }
    }
    
    @discardableResult
    func anchor(centerX: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)? = nil,
                    centerY: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)? = nil,
                    top: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)? = nil,
                    leading: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)? = nil,
                    trailing: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)? = nil,
                    left: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)? = nil,
                    right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)? = nil,
                    bottom: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)? = nil,
                    width: CGFloat? = nil,
                    height: CGFloat? = nil,
                    anchorWidth: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)? = nil,
                    anchorHeight: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)? = nil) -> Constraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint = Constraint()
        
        if let centerX = centerX { constraint.centerX = centerXAnchor.constraint(equalTo: centerX.anchor, constant: centerX.constant) }
        if let centerY = centerY { constraint.centerY = centerYAnchor.constraint(equalTo: centerY.anchor, constant: centerY.constant) }
        if let top = top { constraint.top = topAnchor.constraint(equalTo: top.anchor, constant: top.constant) }
        if let leading = leading { constraint.leading = leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.constant) }
        if let trailing = trailing { constraint.trailing = trailingAnchor.constraint(equalTo: trailing.anchor, constant: -trailing.constant) }
        if let left = left { constraint.left = leftAnchor.constraint(equalTo: left.anchor, constant: left.constant) }
        if let right = right { constraint.right = rightAnchor.constraint(equalTo: right.anchor, constant: -right.constant) }
        if let bottom = bottom { constraint.bottom = bottomAnchor.constraint(equalTo: bottom.anchor, constant: -bottom.constant) }
        
        if let width = width { constraint.width = widthAnchor.constraint(equalToConstant: width) }
        else if let anchorWidth = anchorWidth { constraint.width = widthAnchor.constraint(equalTo: anchorWidth.anchor, multiplier: anchorWidth.multiplier, constant: anchorWidth.constant) }
        
        if let height = height { constraint.height = heightAnchor.constraint(equalToConstant: height) }
        else if let anchorHeight = anchorHeight { constraint.height = heightAnchor.constraint(equalTo: anchorHeight.anchor, multiplier: anchorHeight.multiplier, constant: anchorHeight.constant) }
        
        constraint.activate()
        
        return constraint
    }
    
    @discardableResult
    func anchorFillSuperview(constant: CGFloat = 0.0, inSafeArea: Bool = false) -> Constraint {
        var constraint = Constraint()
        if let superview = superview {
            if inSafeArea {
                if #available(iOS 11.0, *) {
                    constraint = anchor(
                        top: (superview.safeAreaLayoutGuide.topAnchor, constant),
                        left: (superview.safeAreaLayoutGuide.leftAnchor, constant),
                        right: (superview.safeAreaLayoutGuide.rightAnchor, constant),
                        bottom: (superview.safeAreaLayoutGuide.bottomAnchor, constant)
                    )
                } else {
                    let topBarHeight = 44.0 + UIApplication.shared.statusBarFrame.height
                    constraint = anchor(
                        top: (superview.topAnchor, constant + topBarHeight),
                        left: (superview.leftAnchor, constant),
                        right: (superview.rightAnchor, constant),
                        bottom: (superview.bottomAnchor, constant)
                    )
                }
            } else {
                constraint = anchor(
                    top: (superview.topAnchor, constant),
                    left: (superview.leftAnchor, constant),
                    right: (superview.rightAnchor, constant),
                    bottom: (superview.bottomAnchor, constant)
                )
            }
        }
        return constraint
    }
}
