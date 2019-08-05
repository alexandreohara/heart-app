//
//  CardView.swift
//  heart-app
//
//  Created by Alexandre Ohara on 04/08/19.
//  Copyright © 2019 Alexandre Ohara. All rights reserved.
//

import UIKit
import Hero

class CardView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    //let imageView = UIImageView(image: #imageLiteral(resourceName: "Unsplash6"))
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    //required init?(coder aDecoder: NSCoder) { fatalError() }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: FontSize.TITLE_LABEL_DEFAULT)
        subtitleLabel.font = UIFont.systemFont(ofSize: FontSize.SUBTITLE_LABEL_DEFAULT)
        //imageView.contentMode = .scaleAspectFill
        
        //addSubview(imageView)
        addSubview(visualEffectView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //imageView.frame = bounds
        visualEffectView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 80)
        titleLabel.frame = CGRect(x: 20, y: 20, width: bounds.width - 40, height: 40)
        subtitleLabel.frame = CGRect(x: 20, y: 45, width: bounds.width - 40, height: 30)
    }
}
