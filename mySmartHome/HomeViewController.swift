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
    @IBOutlet var humidityChart: Chart!
    @IBOutlet var lightChart: Chart!
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
    
    //MARK: - Utils
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: scrollContentView.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get backend data
        getServiceRequests()
        getLoanRequests()
        getInsuranceRequests()
        getCustomers()
        
        //draw graphs
        drawTemperatureChart()
        drawHumidityChart()
        drawLightChart()
        activityController.startAnimating()
    }
    
    //MARK: - Draw charts
    
    func drawTemperatureChart() {
        let data = [(x: 0.0, y: 0),
                    (x: 3, y: 2.5),
                    (x: 4, y: -2),
                    (x: 5, y: 2.3),
                    (x: 7, y: 3),
                    (x: 8, y: 2.2),
                    (x: 9, y: 2.5)]
        let series = ChartSeries(data: data)
        series.color = ChartColors.greyColor()
        series.area = true
        temperatureChart.add(series)
        temperatureChart.delegate = self
        temperatureChart.xLabelsFormatter = { String(Int(round($1))) + "h" }
    }
    
    func drawHumidityChart() {
        let data = [(x: 0.0, y: 0),
                    (x: 3, y: 5.5),
                    (x: 4, y: 2),
                    (x: 5, y: 2.3),
                    (x: 7, y: 7),
                    (x: 8, y: 3.2),
                    (x: 9, y: 4.5)]
        let series = ChartSeries(data: data)
        series.color = ChartColors.blueColor()
        series.area = true
        humidityChart.add(series)
        humidityChart.delegate = self
        humidityChart.xLabelsFormatter = { String(Int(round($1))) + "h" }
    }
    
    func drawLightChart() {
        let data = [(x: 0.0, y: 0),
                    (x: 3, y: 2.5),
                    (x: 4, y: 2.1),
                    (x: 5, y: 2.4),
                    (x: 7, y: 2.9),
                    (x: 8, y: 2.5),
                    (x: 9, y: 2.3)]
        let series = ChartSeries(data: data)
        series.color = ChartColors.blueColor()
        series.area = true
        lightChart.add(series)
        lightChart.delegate = self
        lightChart.xLabelsFormatter = { String(Int(round($1))) + "h" }
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
    
    //MARK: - Get data
    
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
            DispatchQueue.main.async {
                print("customers count: " + self.serviceRequests.count.description)
                self.loyaltyPointsCountLabel.text = self.serviceRequests.count.description
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
