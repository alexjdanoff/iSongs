//
//  UIView+Extension.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 28.01.2023.
//

import UIKit

public extension UIView {
    
    @discardableResult
    func addBlur(style: UIBlurEffect.Style = .regular) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        blurBackground.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        blurBackground.alpha = 0
        addSubview(blurBackground)
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.5) {
                blurBackground.alpha = 1
            }
        }
        
        return blurBackground
    }
}
