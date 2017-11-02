//
//  HomeViewController.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/22/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import Foundation
import SwiftChart

class HomeViewController : UIViewController, ChartDelegate {
    
    @IBOutlet var temperatureChart: Chart!
    @IBOutlet var temperatureChartLabel: UILabel!
    
    @IBOutlet var humidityChart: Chart!
    @IBOutlet var humidityChartLabel: UILabel!
    
    @IBOutlet var lightChart: Chart!
    @IBOutlet var lightChartLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollContentView: UIView!
    @IBOutlet var activityController: UIActivityIndicatorView!
    
    var serviceRequests = [ServiceRequest]()
    @IBOutlet var serviceRequestsCountLabel: UILabel!
    
    var insuranceRequests = [InsuranceRequest]()
    @IBOutlet var insuranceRequestsCountLabel: UILabel!
    
    var loanRequests = [LoanRequest]()
    @IBOutlet var loanRequestsCountLabel: UILabel!
    
    var customers = [Customer]()
    @IBOutlet var loyaltyPointsCountLabel: UILabel!
    
    private var timerToRefreshCharts : Timer? = nil
    private var dateFormatter = DateFormatter()
    
    //MARK: - Utils
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: scrollContentView.frame.size.height)
        
        //setup dateFormatter
        dateFormatter.dateFormat = "HH.mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get backend data
        getBackendData()
        
        //draw charts
        enableTimerToRefreshCharts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerToRefreshCharts?.invalidate()
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Draw charts
    
    func enableTimerToRefreshCharts() {
        //timer for refreshing charts
        timerToRefreshCharts = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            DispatchQueue.main.async {
                self.drawCharts()
            }
        }
    }
    
    func drawCharts() {
        drawTemperatureChart()
        drawHumidityChart()
        drawLightChart()
        activityController.startAnimating()
    }
    
    func drawChart(_ chart: Chart, deviceMeasures: [DeviceMeasure], seriesColor: UIColor) {
        var chartData = [(x: Float, y: Float)]()
        for deviceMeasure in deviceMeasures {
            let timeInternal = TimeInterval(deviceMeasure.timestamp!)/1000
            let stringValue = self.dateFormatter.string(from: Date(timeIntervalSince1970:timeInternal))
            print(stringValue)
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
    
    func drawTemperatureChart() {
        let device = IoTAPIConfig.iotInstance().device
        let capability = IoTAPIConfig.iotInstance().device?.capabilities[0]
        //temperatureChartLabel.text = String(format: "   %@", (capability?.properties![0].name?.uppercased())!)
        IoTAPIConfig.iotInstance().readDeviceMeasures(of: capability!,
                                                      device: device!) { (deviceMeasures) in
                                                        
                                                        DispatchQueue.main.async {
                                                            self.drawChart(self.temperatureChart,
                                                                           deviceMeasures: deviceMeasures!,
                                                                           seriesColor: ChartColors.darkGreenColor())
                                                        } 
        }
    }
    
    func drawHumidityChart() {
        let device = IoTAPIConfig.iotInstance().device
        let capability = IoTAPIConfig.iotInstance().device?.capabilities[1]
        //humidityChartLabel.text = String(format: "   %@", (capability?.properties![0].name?.uppercased())!)
        IoTAPIConfig.iotInstance().readDeviceMeasures(of: capability!,
                                                      device: device!) { (deviceMeasures) in
                                                        DispatchQueue.main.async {
                                                            self.drawChart(self.humidityChart,
                                                                           deviceMeasures: deviceMeasures!,
                                                                           seriesColor: ChartColors.blueColor())
                                                        }
        }
    }
    
    func drawLightChart() {
        let device = IoTAPIConfig.iotInstance().device
        let capability = IoTAPIConfig.iotInstance().device?.capabilities[2]
        //lightChartLabel.text = String(format: "   %@", (capability?.properties![0].name?.uppercased())!)
        IoTAPIConfig.iotInstance().readDeviceMeasures(of: capability!,
                                                      device: device!) { (deviceMeasures) in
                                                        DispatchQueue.main.async {
                                                            self.drawChart(self.lightChart,
                                                                           deviceMeasures: deviceMeasures!,
                                                                           seriesColor: ChartColors.blueColor())
                                                        }
                                                        
        }
    }
    
    // Chart delegate
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
    
    //MARK: - Get backend data
    
    func getBackendData() {
        getServiceRequests()
        getLoanRequests()
        getInsuranceRequests()
        getCustomers()
    }
    
    func getServiceRequests() {
        APIConfig.instance().getServiceRequests { (list) in
            self.serviceRequests.removeAll()
            self.serviceRequests = list!
            DispatchQueue.main.async {
                print("service requests count: " + self.serviceRequests.count.description)
                self.serviceRequestsCountLabel.text = self.serviceRequests.count.description
            }
        }
    }
    
    func getLoanRequests() {
        APIConfig.instance().getLoanRequests { (list) in
            self.loanRequests.removeAll()
            self.loanRequests = list!
            DispatchQueue.main.async {
                print("loan requests count: " + self.loanRequests.count.description)
                self.loanRequestsCountLabel.text = self.loanRequests.count.description
            }
        }
    }
    
    func getInsuranceRequests() {
        APIConfig.instance().getInsuranceRequests { (list) in
            self.insuranceRequests.removeAll()
            self.insuranceRequests = list!
            DispatchQueue.main.async {
                print("insurance requests count: " + self.insuranceRequests.count.description)
                self.insuranceRequestsCountLabel.text = self.insuranceRequests.count.description
            }
        }
    }
    
    func getCustomers() {
        APIConfig.instance().getCustomers { (list) in
            self.customers.removeAll()
            self.customers = list!
            self.findRelavantCustomer()
            DispatchQueue.main.async {
                print("customers count: " + self.customers.count.description)
                self.loyaltyPointsCountLabel.text = APIConfig.instance().customer?.loyalty_points
            }
        }
    }
    
    func findRelavantCustomer() {
        for customer in customers {
            if customer.name?.lowercased() == APIConfig.instance().customerName.lowercased() {
                APIConfig.instance().customer = customer
            }
        }
    }
    
    //MARK: - Navigation
    
    @IBAction func showServiceRequests(_ sender: Any) {
        performSegue(withIdentifier: "showServiceRequests", sender: self)
    }
    
    @IBAction func showInsuranceRequests(_ sender: Any) {
        performSegue(withIdentifier: "showServiceRequests", sender: self)
    }
    
    @IBAction func showLoanRequests(_ sender: Any) {
        performSegue(withIdentifier: "showServiceRequests", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showServiceRequests" {
            //(segue.destination as? ServiceRequestsTableViewController)?.serviceRequests = serviceRequests
        }
    }
}
