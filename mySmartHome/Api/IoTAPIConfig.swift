//
//  IoTAPIConfig.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/30/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit

class IoTAPIConfig: APIConfig {

    static public let IoT_tenant_host = UserDefaults.standard.string(forKey: "tenant_host_preference")!
    static public let IoT_tenant_ID = UserDefaults.standard.string(forKey: "tenant_id_preference")!
    static public let Device_ID = UserDefaults.standard.string(forKey: "device_id_preference")!
    
    private let BASE_URL = "https://" + IoTAPIConfig.IoT_tenant_host + "/iot/core/api/"
    
    private let READ_DEVICE = "v1/devices/"
    private let READ_SENSORTYPE = "v1/sensorTypes/"
    private let READ_CAPABILITIES = "v1/capabilities/"
    
    private static var iotApiConfig : IoTAPIConfig? = nil
    public var device : Device? = nil
    
    static func iotInstance() -> IoTAPIConfig {
        if (iotApiConfig == nil) {
            iotApiConfig = IoTAPIConfig()
        }
        return iotApiConfig!
    }
    
    public func readDevice(of completionHandler: @escaping ([Device]?) -> Void) {
        let url = URL(string: BASE_URL + READ_DEVICE + IoTAPIConfig.Device_ID)!
        let request = URLRequest(url: url)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [String:Any]
            let list = Device.modelsFromDictionaryArray(array: [jsonObject as Any])
            completionHandler(list)
        }
    }
    
    public func readSensorTypes(of device : Device, completionHandler: @escaping ([SensorType]?) -> Void) {
        
        device.capabilities.removeAll()
        device.sensorTypes.removeAll()
        
        //get sensorTypes for all sensors of the device
        for sensor in device.sensors! {
            
            //ignore if sensorTypeId == 0
            if sensor.sensorTypeId == "0" {
                continue
            }
            
            //then, request sensorType information
            let request = URLRequest(url: URL(string: BASE_URL + READ_SENSORTYPE + (sensor.sensorTypeId?.description)!)!)
            _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                let jsonObject = self.convertToJsonObject(data: data) as? [String:Any]
                let list = SensorType.modelsFromDictionaryArray(array: [jsonObject as Any])
                
                for sensorType in list {
                    sensorType.gotAllTheValues = true
                    for capability in sensorType.capabilities! {
                        //read all capabilities from sesnorTypes and save them to a single array
                        device.capabilities.append(capability)
                    }
                }
                
                //save sensorTypes
                device.sensorTypes.append(contentsOf: list)
            }
        }
        
        //return
        completionHandler(device.sensorTypes)
    }
    
    public func readDeviceCapability(of device : Device, capabilityID: String, completionHandler: @escaping (Capability?) -> Void) {
        
        let request = URLRequest(url: URL(string: BASE_URL + READ_CAPABILITIES + capabilityID)!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [String:Any]
            let capability = Capability.init(dictionary: (jsonObject! as NSDictionary))
            capability?.gotAllTheValues = true
            
            //add capability info into device
            var notFound = true
            if (capability != nil) {
                for existingCapability in device.capabilities {
                    if existingCapability.id == capability?.id {
                        existingCapability.alternateId = capability?.alternateId
                        existingCapability.properties = capability?.properties
                        existingCapability.name = capability?.name
                        existingCapability.gotAllTheValues = (capability?.gotAllTheValues)!
                        notFound = false
                    }
                }
                
                //if not found, then add it to the "capabilities" list
                if notFound {
                    device.capabilities.append(capability!)
                }
            }
            
            completionHandler(capability)
        }
    }
    
    public func readDeviceMeasures(of device : Device, completionHandler: @escaping ([DeviceMeasure]?) -> Void) {
        
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
         These details given by Mayur: it stores the data in PostgrySQL DB provided by IoT4.0 platform
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
