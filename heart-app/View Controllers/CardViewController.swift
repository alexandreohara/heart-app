//
//  ViewController.swift
//  heart-app
//
//  Created by Alexandre Ohara on 04/08/19.
//  Copyright © 2019 Alexandre Ohara. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var mainTitle: UITextView!
    @IBOutlet weak var historyView: RoundedCardWrapperView!
    @IBOutlet weak var profileView: RoundedCardWrapperView!
    @IBOutlet weak var medicineView: RoundedCardWrapperView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCards()
        icon.image = UIImage(named: "heart")
        mainTitle.text = "Heart Monitor"
        mainTitle.font = UIFont.boldSystemFont(ofSize: FontSize.MAIN_TITLE)
        historyView.delegate = self
        profileView.delegate = self
        medicineView.delegate = self
        animate(image: icon)
        
        
    }
    
    func loadCards() {
        historyView.cardView.titleLabel.text = "HISTÓRICO"
        historyView.cardView.subtitleLabel.text = "Veja seus últimos registros"
        historyView.cardView.backgroundColor = UIColor.red
        historyView.cardView.titleLabel.textColor = UIColor.white
        historyView.cardView.subtitleLabel.textColor = UIColor.white
        
        profileView.cardView.titleLabel.text = "FICHA MÉDICA"
        profileView.cardView.subtitleLabel.text = "Tenha a sua ficha em qualquer lugar"
        profileView.cardView.backgroundColor = UIColor.red
        profileView.cardView.titleLabel.textColor = UIColor.white
        profileView.cardView.subtitleLabel.textColor = UIColor.white
        
        medicineView.cardView.titleLabel.text = "REMÉDIOS"
        medicineView.cardView.subtitleLabel.text = "Verifique os remédios agendados pelo seu médico"
        medicineView.cardView.backgroundColor = UIColor.red
        medicineView.cardView.titleLabel.textColor = UIColor.white
        medicineView.cardView.subtitleLabel.textColor = UIColor.white
    }
    
    func animate(image: UIImageView) {
        UIView.animate(withDuration: 0.75, animations: {
            image.transform = CGAffineTransform(scaleX: 0.85, y: 0.85);
        }) { (bool) in
            UIView.animate(withDuration: 0.75, animations: {
                image.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            }) { (bool) in
                self.animate(image: image)
            }
        }
        
    }
    
}

extension CardViewController: RoundedCardWrapperDelegate {
    func handleTap(heroId: String?) {
        if (heroId == "history") {
            let vc = HistoryViewController()
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .none
            
            vc.cardView.hero.id = heroId
            
            vc.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
            //vc.cardView.imageView.image = UIImage(named: "Unsplash\(data)")
            
            vc.contentCard.hero.modifiers = [.source(heroID: heroId!), .spring(stiffness: 250, damping: 25)]
            
            //vc.contentView.hero.modifiers = [.useNoSnapshot, .forceAnimate, .spring(stiffness: 0, damping: 25)]
            
            vc.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
            
            present(vc, animated: true, completion: nil)
        }
    }
    
}
