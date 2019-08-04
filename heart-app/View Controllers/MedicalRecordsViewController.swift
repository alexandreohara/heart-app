//
//  MedicalRecordsViewController.swift
//  heart-app
//
//  Created by Alexandre Ohara on 04/08/19.
//  Copyright © 2019 Alexandre Ohara. All rights reserved.
//

import UIKit
import Hero

class MedicalRecordsViewController: UIViewController {
    //let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let contentCard = UIView()
    let cardView = CardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        //view.addSubview(visualEffectView)
        
        cardView.titleLabel.text = "FICHA MÉDICA"
        cardView.subtitleLabel.text = "Tenha a sua ficha em qualquer lugar"
        cardView.titleLabel.font = UIFont.boldSystemFont(ofSize: FontSize.TITLE_LABEL_BIG)
        cardView.subtitleLabel.font = UIFont.systemFont(ofSize: FontSize.SUBTITLE_LABEL_BIG)
        cardView.backgroundColor = UIColor.white
        
        contentCard.backgroundColor = .white
        contentCard.clipsToBounds = true
        contentCard.addSubview(cardView)
        view.addSubview(contentCard)
        
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePan(gr:))))
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePan(gr:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        //visualEffectView.frame  = bounds
        contentCard.frame  = bounds
        cardView.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 80)
    }
    
    @objc func handlePan(gr: PanDirectionGestureRecognizer) {
        let translation = gr.translation(in: view)
        let velocity = gr.velocity(in: view)
        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            if gr.direction == .vertical {
                Hero.shared.update(translation.y / view.bounds.height)
                if translation.y > 100 {
                    Hero.shared.finish()
                    gr.state = .cancelled
                }
            } else if gr.direction == .horizontal {
                Hero.shared.update(translation.x / view.bounds.width)
                if translation.x > 50 {
                    Hero.shared.finish()
                    gr.state = .cancelled
                }
            }
        default:
            if gr.direction == .vertical {
                print("translation.y: \(translation.y), velocity.y: \(velocity.y), view.bounds.height: \(view.bounds.height)")
                if ((translation.y + velocity.y) / view.bounds.height) > 0.5 || gr.state == .cancelled {
                    Hero.shared.finish()
                } else {
                    Hero.shared.cancel()
                }
            } else if gr.direction == .horizontal {
                print("translation.x: \(translation.x), velocity.x: \(velocity.x), view.bounds.width: \(view.bounds.width)")
                if ((translation.x + velocity.x) / view.bounds.width) > 0.5 || gr.state == .cancelled {
                    Hero.shared.finish()
                } else {
                    Hero.shared.cancel()
                }
            }
        }
    }
}
