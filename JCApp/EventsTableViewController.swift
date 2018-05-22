//
//  EventsTableViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 22/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import JCApiClient

class EventsTableViewController: UITableViewController {

    var localArray: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get remote data
        self.updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = self.localArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    // MARK: IBActions
    @IBAction func updateAction(_ sender: Any) {
        self.updateData()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: Local Methods
    private func updateData() {
        Event.getAllEvents(completeCall: { (returnData) in
            if let returnData = returnData {
                self.localArray = returnData
                self.tableView.reloadData()
            }
        }) { (errorMessage) in
            print(errorMessage)
            // TODO: Handle error message with user
        }
    }
    
}
