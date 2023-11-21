//
//  HomeTabBar.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 21.11.23.
//

import UIKit

class HomeTabBar: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setup()
        drawTopLayer()
        addTopShadow()
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.isTranslucent = true
        var tabFrame = self.frame
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottomPadding = window!.safeAreaInsets.bottom
        tabFrame.size.height = 65 + bottomPadding
        tabFrame.origin.y = self.frame.origin.y + self.frame.height - 50 - bottomPadding
        self.frame = tabFrame
        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })
    }
    
    private func addTopShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    private func drawTopLayer() {
        if let sublayers = self.layer.sublayers {
            sublayers.forEach {
                if $0.name == "topBorder" {
                    $0.removeFromSuperlayer()
                }
            }
        }
              
        let topBorderWidth: CGFloat = 1.0

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: topBorderWidth)
        topBorder.borderColor = UIColor.blue.cgColor
        topBorder.name = "topBorder"
        self.layer.addSublayer(topBorder)
    }
    
}
