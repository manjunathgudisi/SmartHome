//
//  GraphViewController.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 11/3/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit
import SwiftChart

class GraphViewController: UIViewController {
    
    @IBOutlet var chart: Chart!
    @IBOutlet var chartNameLabel: UILabel!
    @IBOutlet var activityController: UIActivityIndicatorView!
    
    private var timerToRefreshCharts : Timer? = nil
    private var dateFormatter = DateFormatter()
    
    public var chartName = "Graph"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if chartNameLabel != nil {
            chartNameLabel.text = chartName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
