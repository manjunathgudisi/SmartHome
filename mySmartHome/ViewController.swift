//
//  ViewController.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/16/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var activityIndiactor: UIActivityIndicatorView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        //validate
        if (usernameTextField.text?.isEmpty)! {
            APIConfig.instance().showAlert(title: "", message: "Please enter login details")
            return
        }
        
        //if valid, then
        APIConfig.instance().customerName = usernameTextField.text!
        activityIndiactor.startAnimating()
        
        //read device
        IoTAPIConfig.iotInstance().readDevice { (devices) in
            print(devices?.description as Any)
            
            //if there are no devices found, dont do anyhting. Just return.
            if devices?.count == 0 {
                self.activityIndiactor.stopAnimating()
                let message = "Theare are no devices with an ID of " + IoTAPIConfig.Device_ID
                APIConfig.instance().showAlert(title: "No device found", message: message)
                return
            }
            
            //if a device found
            IoTAPIConfig.iotInstance().device = devices?.first
            
            //then, get sensorTypes and its capabilities
            DispatchQueue.main.async {
                let device = IoTAPIConfig.iotInstance().device
                IoTAPIConfig.iotInstance().readSensorTypes(of: device!, completionHandler: { (sensorTypes) in
                    print(sensorTypes?.description as Any)
                    self.activityIndiactor.stopAnimating()
                    //and then, finally go to dashboard page
                    self.performSegue(withIdentifier: "showDashboard", sender: self)
                })
            }
        }
    }
    
}

