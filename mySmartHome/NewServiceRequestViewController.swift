//
//  NewServiceRequestViewController.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/29/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit

class NewServiceRequestViewController: UITableViewController, UITextFieldDelegate {
    
    var serviceRequest : ServiceRequest? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        serviceRequest = ServiceRequest(dictionary: NSDictionary())
        serviceRequest?.serviceRequestID = Int(arc4random_uniform(31000))
        serviceRequest?.customerID = 1
        serviceRequest?.timestamp = dateFormatter.string(from: Date())
        serviceRequest?.status = "Open"
        serviceRequest?.title = ""
        serviceRequest?.description = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(red: (68.0/255.0), green: (94.0/255.0), blue: (117.0/255.0), alpha: 1.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save,
                                                            target: self,
                                                            action: #selector(NewServiceRequestViewController.createServiceRequest(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell
        
        // Configure the cell...
        cell?.textField1.tag = indexPath.row
        cell?.textField1.delegate = self
        
        switch indexPath.row {
        case 0:
            cell?.label1.text = "Title"
            cell?.textField1.text = serviceRequest?.title
        case 1:
            cell?.label1.text = "Description"
            cell?.textField1.text = serviceRequest?.description
        case 2:
            cell?.label1.text = "Status"
            cell?.textField1.text = serviceRequest?.status
        default:
            cell?.label1.text = ""
            cell?.textField1.text = ""
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            serviceRequest?.title = textField.text
        case 1:
            serviceRequest?.description = textField.text
        case 2:
            serviceRequest?.status = textField.text
        default:
            serviceRequest?.title = textField.text
        }
    }
    
    //MARK: - Navigation
    
    @IBAction func createServiceRequest(_ sender: Any) {
        
        APIConfig.instance().createServiceRequest(serviceRequest!) { (jsonObject) in
            DispatchQueue.main.async {
                let message = String(format:"Service request %d created successfully", (self.serviceRequest?.serviceRequestID)!)
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}
