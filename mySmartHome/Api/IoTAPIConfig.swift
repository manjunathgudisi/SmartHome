//
//  IoTAPIConfig.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/30/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit

class IoTAPIConfig: APIConfig {

    private let BASE_URL = "https://com-iotaedemo.eu10.cp.iot.sap/iot/core/api/"
    
    private let READ_DEVICE = "v1/devices/"
    private let READ_SENSORTYPE = "v1/sensorTypes/"
    private let READ_CAPABILITIES = "v1/capabilities/"
    
    private static var iotApiConfig : IoTAPIConfig? = nil
    
//    static func instance() -> IoTAPIConfig {
//        if (iotApiConfig == nil) {
//            iotApiConfig = IoTAPIConfig()
//        }
//        return iotApiConfig!
//    }
    
    public func readDevice(_ deviceId : String, completionHandler: @escaping ([Device]?) -> Void) {
        let request = URLRequest(url: URL(string: BASE_URL + READ_DEVICE + deviceId)!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [Any]
            let list = Device.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
            completionHandler(list)
        }
    }
    
    public func readSensorTypes(of device : Device, completionHandler: @escaping ([SensorType]?) -> Void) {
        
        var sensorTypes = [SensorType]()
        
        //get sensorTypes for all sensors of the device
        for sensor in device.sensors! {
            
            //then, request sensorType information
            let request = URLRequest(url: URL(string: BASE_URL + READ_SENSORTYPE + (sensor.sensorTypeId?.description)!)!)
            _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                let jsonObject = self.convertToJsonObject(data: data) as? [Any]
                let list = SensorType.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
                sensorTypes.append(contentsOf: list)
            }
        }
        
        //read all capabilities from sesnorTypes and save them to a single array
        device.capabilities?.removeAll()
        for sensorType in sensorTypes {
            for capability in sensorType.capabilities! {
                device.capabilities?.append(capability)
            }
        }
        
        //return
        completionHandler(sensorTypes)
    }
    
    public func readDeviceMeasures(_ device : Device, completionHandler: @escaping ([DeviceMeasure]?) -> Void) {
        
        let request = URLRequest(url: URL(string: BASE_URL + READ_DEVICE + (device.id?.description)! + "/measures?skip=0&top=100")!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [Any]
            let list = DeviceMeasure.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
            completionHandler(list)
        }
    }
    
    public func readDeviceMeasures(of capabailityID: String, device : Device, completionHandler: @escaping ([DeviceMeasure]?) -> Void) {
        
        let request = URLRequest(url: URL(string: BASE_URL + READ_DEVICE + (device.id?.description)! + "/measures" + "?filter=capabilityId%20eq%20" + capabailityID + "&skip=0&top=100")!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [Any]
            let list = DeviceMeasure.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
            completionHandler(list)
        }
    }
    
    override public func getAuthenticationToken() -> String {
        /*
        https://catalyst-poc.eu10.cp.iot.sap
         User/pwd/tenant: datamodeler/Abcd1234/3
         */
        
        let username = "datamodeler"
        let password = "Abcd1234"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8.rawValue)
        let base64EncodedString = loginData?.base64EncodedString()
        let authString = "Basic " + base64EncodedString!
        return authString
    }
    
}
