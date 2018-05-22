//
//  EventsTableViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 22/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import JCApiClient

class EventsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {

    var localArray: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Large titles
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Color
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .backGroundColor
        self.navigationController?.navigationBar.backgroundColor = .backGroundColor
        
        // Peek and Pop Register
        self.registerForPreviewing(with: self, sourceView: self.tableView)
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.localArray[indexPath.row] as Event
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? EventDetailsViewController else {
            return
        }
        viewController.item = item
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    
    // MARK: UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        let item = self.localArray[indexPath.row] as Event
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? EventDetailsViewController else {
            return nil
        }
        
        viewController.item = item
        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
