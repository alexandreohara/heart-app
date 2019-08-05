//
//  MedicineListViewController.swift
//  heart-app
//
//  Created by Alexandre Ohara on 04/08/19.
//  Copyright © 2019 Alexandre Ohara. All rights reserved.
//

import UIKit
import Hero

class MedicineListViewController: UIViewController {
    let contentCard = UIView()
    let cardView = CardView()
    let medicineCard = CardView()
    let medicineDescription = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        cardView.titleLabel.text = "Remédios"
        cardView.subtitleLabel.text = "Verifique os remédios agendados pelo seu médico"
        cardView.titleLabel.font = UIFont.boldSystemFont(ofSize: FontSize.TITLE_LABEL_BIG)
        cardView.subtitleLabel.font = UIFont.systemFont(ofSize: FontSize.SUBTITLE_LABEL_BIG)
        cardView.backgroundColor = UIColor.white
        
        contentCard.backgroundColor = UIColor.white
        contentCard.clipsToBounds = true
        contentCard.addSubview(cardView)
        contentCard.addSubview(medicineCard)
        medicineCard.addSubview(medicineDescription)
        
        view.addSubview(contentCard)
        
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePan(gr:))))
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePan(gr:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        contentCard.frame  = bounds
        cardView.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 80)
        medicineCard.frame = CGRect(x:20, y: cardView.frame.maxY + 20, width: bounds.width - 40, height: 240)
        medicineCard.layer.cornerRadius = CardConstants.CORNER_RADIUS
        medicineCard.backgroundColor = UIColor(red:0.77, green:0.67, blue:0.95, alpha:1.0)
        medicineCard.titleLabel.text = "Propanolol"
        medicineCard.subtitleLabel.text = "2 pílulas a cada 8 horas"
        medicineDescription.frame = CGRect(x:20, y: cardView.visualEffectView.frame.maxY + 4, width: medicineCard.frame.width - 20, height: medicineCard.frame.height - medicineCard.visualEffectView.frame.height)
        medicineDescription.numberOfLines = 0
        medicineDescription.text = """
        Prazo de validade: 24 meses a partir da data de fabricação, impressa na embalagem externa do produto.\n
        Não utilize o medicamento se o prazo de validade estiver vencido.\n
        Conservar em temperatura ambiente (entre 15 e 30ºC). Proteger da umidade.
        """
        medicineDescription.font = UIFont.systemFont(ofSize: FontSize.SUBTITLE_LABEL_DEFAULT)
        
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
