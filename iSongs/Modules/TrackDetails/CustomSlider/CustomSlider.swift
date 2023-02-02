//
//  CustomSlider.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 29.01.2023.
//

import UIKit

class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 6
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.tintColor = #colorLiteral(red: 0.937254902, green: 0.1960784314, blue: 0.3725490196, alpha: 1)
        self.setThumbImage(UIImage(), for: .normal)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}
