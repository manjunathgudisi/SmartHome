//
//  APIConfig.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/29/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit
import Foundation

class APIConfig: NSObject {

    private let BASE_URL = "https://smarthomebiznetwork.cfapps.eu10.hana.ondemand.com/api/"
    
    private let SERVICE_REQUESTS = "serviceRequest"
    private let INSURANCE_REQUESTS = "insuranceRequest"
    private let LOAN_REQUESTS = "loanRequest"
    private let CUSTOMER = "customer"
    
    private static var apiConfig : APIConfig? = nil
    
    public var customerName = ""
    public var customer : Customer? = nil
    
    static func instance() -> APIConfig {
        if (apiConfig == nil) {
            apiConfig = APIConfig()
        }
        return apiConfig!
    }
    
    public func getServiceRequests(completionHandler: @escaping ([ServiceRequest]?) -> Void) {
        let request = URLRequest(url: URL(string: BASE_URL + SERVICE_REQUESTS)!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [Any]
            let list = ServiceRequest.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
            completionHandler(list)
        }
    }
    
    public func createServiceRequest(_ serviceRequest : ServiceRequest, completionHandler: @escaping ([String:Any]?) -> Void) {
        var request = URLRequest(url: URL(string: BASE_URL + SERVICE_REQUESTS)!)
        request.httpMethod = "POST"
        request.httpBody = convertToData(serviceRequest.dictionaryRepresentation())
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [String:Any]
            completionHandler(jsonObject)
        }
    }
    
    public func getInsuranceRequests(completionHandler: @escaping ([InsuranceRequest]?) -> Void) {
        let request = URLRequest(url: URL(string: BASE_URL + INSURANCE_REQUESTS)!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [Any]
            let list = InsuranceRequest.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
            completionHandler(list)
        }
    }
    
    public func getLoanRequests(completionHandler: @escaping ([LoanRequest]?) -> Void) {
        let request = URLRequest(url: URL(string: BASE_URL + LOAN_REQUESTS)!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [Any]
            let list = LoanRequest.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
            completionHandler(list)
        }
    }
    
    public func getCustomers(completionHandler: @escaping ([Customer]?) -> Void) {
        let request = URLRequest(url: URL(string: BASE_URL + CUSTOMER)!)
        _ = executeAuthenticatedRequest(request: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            let jsonObject = self.convertToJsonObject(data: data) as? [Any]
            let list = Customer.modelsFromDictionaryArray(array: (jsonObject! as NSArray))
            completionHandler(list)
        }
    }
    
    // MARK: - APiConfig Reuse methods
    
    public func executeAuthenticatedRequest(request: URLRequest, _ autoErrorHandling: Bool = false, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        var request = request
        request.setValue(getAuthenticationToken(), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return executeRequest(request:request, autoErrorHandling, completionHandler: completionHandler)
    }
    
    public func executeRequest(request: URLRequest, _ autoErrorHandling: Bool = false, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil && autoErrorHandling {
                self.showError(error: error)
            }
            completionHandler(data, response, error)
        }
        task.resume()
        return task
    }
    
    public func showError(error: Error?) {
        showAlert(title: "Error", message: error?.localizedDescription)
    }
    
    public func showAlert(title: String, message: String?,_ handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        currentTopViewController()?.present(alert, animated: true, completion: nil)
    }
    
    public func currentTopViewController() -> UIViewController? {
        var topVC: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
    
    public func getAuthenticationToken() -> String {
        let username = "i302342"
        let password = "@SAPscpla1!"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8.rawValue)
        let base64EncodedString = loginData?.base64EncodedString()
        let authString = "Basic " + base64EncodedString!
        return authString
    }
    
    func convertToJsonObject(data : Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            print(error.localizedDescription)
            let errordata = String(data: data, encoding: .utf8) ?? ""
            print(errordata)
        }
        return nil
    }
    
    func convertToData(_ dictionary : NSDictionary) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return jsonData
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
