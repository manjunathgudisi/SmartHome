//
//  HomeViewController.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/22/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit

class HomeViewController : UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollContentView: UIView!
    @IBOutlet var statsView: UIView!
    @IBOutlet var activityController: UIActivityIndicatorView!
    
    var serviceRequests = [ServiceRequest]()
    @IBOutlet var serviceRequestsCountLabel: UILabel!
    
    var insuranceRequests = [InsuranceRequest]()
    @IBOutlet var insuranceRequestsCountLabel: UILabel!
    
    var loanRequests = [LoanRequest]()
    @IBOutlet var loanRequestsCountLabel: UILabel!
    
    var customers = [Customer]()
    @IBOutlet var loyaltyPointsCountLabel: UILabel!
    
    private var charts = [GraphViewController]()
    
    //MARK: - Utils
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add charts
        addCharts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get backend data
        getBackendData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for chart in charts {
            chart.startRefreshingChart()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for chart in charts {
            chart.stopRefreshingChart()
        }
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: - Add charts
    
    func addCharts() {
        let device = IoTAPIConfig.iotInstance().device
        let capabilities = device?.capabilities
        
        let x = 8
        let offset = (statsView.frame.origin.y + statsView.frame.size.height)
        var frame = CGRect(x: CGFloat(x), y: offset+8, width: statsView.frame.size.width, height: statsView.frame.size.height)
        
        for capablity in capabilities! {
            let chart = storyboard?.instantiateViewController(withIdentifier: "Chart") as! GraphViewController
            chart.capability = capablity
            charts.append(chart)
            
            //add to scroll view
            chart.view.frame = frame
            scrollContentView.addSubview(chart.view)
            frame.origin.y += (offset + 8)
        }
        
        //set content size
        scrollContentView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: (frame.origin.y+frame.size.height))
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: scrollContentView.frame.size.height)
        scrollView.setNeedsDisplay()
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
