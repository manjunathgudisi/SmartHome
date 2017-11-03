//
//  GraphViewController.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 11/3/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit
import SwiftChart

class GraphViewController: UIViewController, ChartDelegate {
    
    @IBOutlet var chart: Chart!
    @IBOutlet var chartNameLabel: UILabel!
    @IBOutlet var activityController: UIActivityIndicatorView!
    
    private var timerToRefreshChart : Timer? = nil
    private var dateFormatter = DateFormatter()
    
    public var chartName = "Graph"
    public var capability : Capability? = nil
    public var seriesColor = UIColor.darkGray

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if chartNameLabel != nil {
            chartNameLabel.text = chartName
        }
        
        //setup dateFormatter
        dateFormatter.dateFormat = "HH.mm"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK:- draw chart
    
    private func enableTimerToRefreshChart() {
        //timer for refreshing charts
        timerToRefreshChart = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            DispatchQueue.main.async {
                self.readCapabilityMeasures()
            }
        }
    }
    
    private func drawChart(deviceMeasures: [DeviceMeasure]) {
        var chartData = [(x: Float, y: Float)]()
        for deviceMeasure in deviceMeasures {
            let timeInternal = TimeInterval(deviceMeasure.timestamp!)/1000
            let stringValue = self.dateFormatter.string(from: Date(timeIntervalSince1970:timeInternal))
            //print(stringValue)
            let object = (x: Float(stringValue)!, y: Float((deviceMeasure.measure?.value)!))
            chartData.append(object)
        }
        
        //remove if any series
        chart.series.removeAll()
        
        //then, add series
        let series = ChartSeries(data: chartData)
        series.color = seriesColor
        series.area = true
        chart.add(series)
        chart.delegate = self
        chart.xLabelsFormatter = {
            String($1).replacingOccurrences(of: ".", with: ":")
        }
    }
    
    //MARK:- read capabilities
    
    func readCapabilityMeasures() {
        let device = IoTAPIConfig.iotInstance().device
        IoTAPIConfig.iotInstance().readDeviceMeasures(of: capability!,
                                                      device: device!) { (deviceMeasures) in
                                                        DispatchQueue.main.async {
                                                            self.drawChart(deviceMeasures: deviceMeasures!)
                                                        }
        }
    }

    //MARK:- ChartDelegate
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        //Do something on touch
        //        for item in indexes {
        //            print(item)
        //        }
        
        //        for (serieIndex, dataIndex) in indexes {
        //            if dataIndex != nil {
        //                // The series at serieIndex has been touched
        //                let value = chart.valueForSeries(serieIndex, atIndex: dataIndex)
        //            }
        //        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        // Do something when finished
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        // Do something when ending touching chart
    }
}
