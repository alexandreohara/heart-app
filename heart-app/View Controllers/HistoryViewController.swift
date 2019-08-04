//
//  HistoryViewController.swift
//  heart-app
//
//  Created by Alexandre Ohara on 04/08/19.
//  Copyright © 2019 Alexandre Ohara. All rights reserved.
//

import UIKit
import Hero
import Charts

class HistoryViewController: UIViewController, UIGestureRecognizerDelegate {
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    let contentCard = UIView()
    let cardView = CardView()
    let contentView = UILabel()
    let chartView = LineChartView()
    var shouldHideData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(visualEffectView)
        
        cardView.titleLabel.text = "Histórico"
        cardView.subtitleLabel.text = "Veja seus últimos registros"
        cardView.titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        cardView.subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        cardView.backgroundColor = UIColor.white
        
        contentView.numberOfLines = 0
        contentCard.backgroundColor = .white
        contentCard.clipsToBounds = true
        
        //contentCard.addSubview(contentView)
        contentCard.addSubview(chartView)
        contentCard.addSubview(cardView)
        view.addSubview(contentCard)
        
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePan(gr:))))
        view.addGestureRecognizer(PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePan(gr:))))
        
        // cria gráfico de linha
        createChart()
        
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        visualEffectView.frame  = bounds
        contentCard.frame  = bounds
        cardView.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 80)
        contentView.frame = CGRect(x: 20, y: bounds.width + 20, width: bounds.width - 40, height: bounds.height - bounds.width - 20)
        chartView.frame = CGRect(x: 0, y: 80, width: bounds.width - 40, height: 2*bounds.height/3)
    }
    
    func createChart() {
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .bottomRight
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: 140, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .topRight
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.axisMaximum = 190
        leftAxis.axisMinimum = 50
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        
        let marker = BalloonMarker(color: UIColor(red:0.58, green:0.02, blue:0.02, alpha:1.0),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        chartView.legend.form = .line
        
        chartView.animate(xAxisDuration: 2.0)
        setDataCount(30, range: UInt32(110))
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 65)
            return ChartDataEntry(x: Double(i), y: val, icon: nil)
        }
        
        let set1 = LineChartDataSet(entries: values, label: "Batimentos Por Minuto")
        set1.drawIconsEnabled = false
        
        //set1.lineDashLengths = [5, 2.5]
        //set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(UIColor.red)
        set1.setCircleColor(UIColor.red)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        //set1.formLineDashLengths = [5, 2.5]
        //set1.formLineWidth = 1
        set1.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
}

extension HistoryViewController : ChartViewDelegate {
    
}
