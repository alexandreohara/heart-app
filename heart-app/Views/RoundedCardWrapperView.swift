//
//  RoundedCardWrapperView.swift
//  heart-app
//
//  Created by Alexandre Ohara on 04/08/19.
//  Copyright © 2019 Alexandre Ohara. All rights reserved.
//

import UIKit
import Hero

class RoundedCardWrapperView: UIView {
    let cardView = CardView()
    
    var isTouched: Bool = false {
        didSet {
            var transform = CGAffineTransform.identity
            if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.transform = transform
            }, completion: nil)
        }
    }
    var delegate: RoundedCardWrapperDelegate?
    
    //required init?(coder aDecoder: NSCoder) { fatalError() }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cardView.layer.cornerRadius = CardConstants.CORNER_RADIUS
        layer.shadowColor = CardConstants.SHADOW_COLOR
        layer.shadowRadius = CardConstants.SHADOW_RADIUS
        layer.shadowOpacity = CardConstants.SHADOW_OPACITY
        layer.shadowOffset = CardConstants.SHADOW_OFFSET
        addSubview(cardView)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardView.layer.cornerRadius = CardConstants.CORNER_RADIUS
        layer.shadowColor = CardConstants.SHADOW_COLOR
        layer.shadowRadius = CardConstants.SHADOW_RADIUS
        layer.shadowOpacity = CardConstants.SHADOW_OPACITY
        layer.shadowOffset = CardConstants.SHADOW_OFFSET
        addSubview(cardView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if cardView.superview == self {
            // this is necessary because we used `.useNoSnapshot` modifier on cardView.
            // we don't want cardView to be resized when Hero is using it for transition
            cardView.frame = bounds
        }
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false
        delegate?.handleTap(heroId: self.hero.id)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false
    }
}

protocol RoundedCardWrapperDelegate: AnyObject {
    func handleTap(heroId: String?)
}
