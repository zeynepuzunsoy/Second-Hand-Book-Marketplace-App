//
//  Extension+CALayer.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 12.06.2023.
//


import UIKit

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.1,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
