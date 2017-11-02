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
    
    private var hasCapabilities = false
    private var timerToCheckCapabilities : Timer? = nil
    
    private var hasSensorTypes = false
    private var timerToCheckSensorTypes : Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //timer for sensortypes
        enableTimerToCheckSensorTypes()
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
        readDevice()
    }
    
    //MARK: - Check for sensorTypes
    
    func enableTimerToCheckSensorTypes() {
        //timer for sensortypes
        timerToCheckSensorTypes = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            DispatchQueue.main.async {
                self.checkSensorTypes()
            }
        }
    }
    
    @objc func checkSensorTypes() {
        
        var gotAllSensorTypes = false
        let device = IoTAPIConfig.iotInstance().device
        
        if (device != nil && device?.sensorTypes != nil && device?.sensorTypes.count != 0) {
            for sensorType in (device?.sensorTypes)! {
                if sensorType.gotAllTheValues == false {
                    gotAllSensorTypes = false
                    break
                } else {
                    gotAllSensorTypes = true
                }
            }
        }
        
        if gotAllSensorTypes {
            timerToCheckSensorTypes?.invalidate()
            DispatchQueue.main.async {
                self.readCapabilities()
                self.enableTimerToCheckCapabilities()
            }
        }
    }
    
    //MARK: - Check for capabilities
    
    func enableTimerToCheckCapabilities() {
        //timer for sensortypes
        timerToCheckCapabilities = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            DispatchQueue.main.async {
                self.checkCapabilities()
            }
        }
    }
    
    @objc func checkCapabilities() {
        
        var gotAllCapabilities = false
        let device = IoTAPIConfig.iotInstance().device
        
        if (device != nil && device?.capabilities != nil && device?.capabilities.count != 0) {
            for capability in (device?.capabilities)! {
                if capability.gotAllTheValues == false {
                    break
                } else {
                    gotAllCapabilities = true
                }
            }
        }
        
        if gotAllCapabilities {
            timerToCheckCapabilities?.invalidate()
            DispatchQueue.main.async {
                self.goToDashboard()
            }
        }
    }
    
    //MARK: - Get device information
    
    private func readDevice() {
        //read device
        IoTAPIConfig.iotInstance().readDevice { (devices) in
            //print(devices?.description as Any)
            
            //if there are no devices found, dont do anyhting. Just return.
            if devices?.count == 0 {
                self.activityIndiactor.stopAnimating()
                let message = "Theare are no devices with an ID of " + IoTAPIConfig.Device_ID
                APIConfig.instance().showAlert(title: "No device found", message: message)
                return
            }
            
            //if a device found
            IoTAPIConfig.iotInstance().device = devices?.first
            
            //then, get sensorTypes
            DispatchQueue.main.async {
                self.readDeviceSensorTypes()
            }
        }
    }
    
    private func readDeviceSensorTypes() {
        let device = IoTAPIConfig.iotInstance().device
        IoTAPIConfig.iotInstance().readSensorTypes(of: device!, completionHandler: { (sensorTypes) in
            //print(sensorTypes?.description as Any)
        })
    }
    
    private func readCapabilities() {
        let device = IoTAPIConfig.iotInstance().device
        for capability in (device?.capabilities)! {
            IoTAPIConfig.iotInstance().readDeviceCapability(of: device!,
                                                            capabilityID: capability.id!,
                                                            completionHandler: { (updatedCapability) in
                                                                print(updatedCapability.debugDescription)
                                                            })
        }
    }
    
    private func goToDashboard() {
        //and then, finally go to dashboard page
        activityIndiactor.stopAnimating()
        self.performSegue(withIdentifier: "showDashboard", sender: self)
    }
    
}

