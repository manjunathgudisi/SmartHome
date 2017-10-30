//
//  ServiceRequestsTableViewController.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/29/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit

class ServiceRequestsTableViewController: UITableViewController {
    
    var serviceRequests = [ServiceRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get service tickets
        getServiceRequests()
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(red: (68.0/255.0), green: (94.0/255.0), blue: (117.0/255.0), alpha: 1.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                                            target: self,
                                                            action: #selector(ServiceRequestsTableViewController.showNewServiceRequest(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return serviceRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell

        // Configure the cell...
        let serviceRequest = serviceRequests[indexPath.row]
        cell?.label1.text = serviceRequest.serviceRequestID?.description
        cell?.label2.text = serviceRequest.title
        cell?.label3.text = String(format: "%@, %@", serviceRequest.status!, serviceRequest.timestamp!)

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Navigation
    
    func getServiceRequests() {
        APIConfig.instance().getServiceRequests { (list) in
            self.serviceRequests.removeAll()
            self.serviceRequests = list!
            DispatchQueue.main.async {
                print("service requests count: " + self.serviceRequests.count.description)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func showNewServiceRequest(_ sender: Any) {
        let newServiceRequest = storyboard?.instantiateViewController(withIdentifier: "NewServiceRequest")
        navigationController?.pushViewController(newServiceRequest!, animated: true)
    }
}
