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
    let contentCard = UIView()
    let cardView = CardView()
    let numberOfRowsAtSection = [4, 7]
    let sections = ["Dados Pessoais", "Ficha médica", "Alergias"]
    let textLabel = [["Nome", "Data de Nascimento", "Contato", "Endereço"], ["Altura", "Peso", "Sexo", "Grupo Sanguíneo", "Alergias", "Fumante", "Medicação"]]
    let detailTextLabel = [["Fulano da Silva", "04/07/1986", "(11)98329-1234", "Av. Professor Luciano Gualberto, 380"], ["1,76", "78kg", "Masculino", "O+", "Intolerante à lactose", "Não", "Amoxilina"]]
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        cardView.titleLabel.text = "FICHA MÉDICA"
        cardView.subtitleLabel.text = "Tenha a sua ficha em qualquer lugar"
        cardView.titleLabel.font = UIFont.boldSystemFont(ofSize: FontSize.TITLE_LABEL_BIG)
        cardView.subtitleLabel.font = UIFont.systemFont(ofSize: FontSize.SUBTITLE_LABEL_BIG)
        cardView.backgroundColor = UIColor.white
        
        
        let barHeight = UIApplication.shared.statusBarFrame.size.height
        let displayWidth = self.view.frame.width
        let displayHeight = self.view.frame.height
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight + 80, width: displayWidth, height: displayHeight - barHeight - 80), style: .grouped)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "MyCell")
        contentCard.backgroundColor = .white
        contentCard.clipsToBounds = true
        contentCard.addSubview(cardView)
        contentCard.addSubview(tableView)
        view.addSubview(contentCard)
        
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePan(gr:))))
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePan(gr:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        contentCard.frame  = bounds
        cardView.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 80)
        
        //let barHeight = UIApplication.shared.statusBarFrame.size.height
        //let displayWidth = self.view.frame.width
        //let displayHeight = self.view.frame.height
        //tableView = UITableView(frame: CGRect(x: 0, y: barHeight + 80, width: displayWidth, height: displayHeight - barHeight - 80))
        tableView.delegate = self
        tableView.dataSource = self
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

extension MedicalRecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)

        cell.textLabel?.text = textLabel[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = detailTextLabel[indexPath.section][indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor(red:0.98, green:0.31, blue:0.31, alpha:1.0)
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    }
}

class SubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
