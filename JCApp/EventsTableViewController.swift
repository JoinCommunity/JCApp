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
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .backGroundColor
        self.navigationController?.navigationBar.backgroundColor = .backGroundColor
        
        // Peek and Pop Register
        self.registerForPreviewing(with: self, sourceView: self.tableView)
        
        // Register Cell
        self.tableView.register(UINib(nibName: "EventCustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Now rows separator
        //self.tableView.separatorStyle = .none
        
        // Dynamic height row
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130.0
        
        // Get remote data
        self.updateLocalData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventCustomCellTableViewCell
        
        let item = self.localArray[indexPath.row]
        cell.nameLabel.text = item.name
        cell.roomLabel.text = item.room
        cell.speakerLabel.text = item.speaker
        //cell.timeLabel.text = item.time
        
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
        self.updateRemoteData()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: Local Methods
    private func updateRemoteData() {
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
    
    private func updateLocalData() {
        if let localCache = Event.getAllLocalEvents() {
            if localCache.count > 0 {
                self.localArray = localCache
                self.tableView.reloadData()
            }
            else {
                self.updateRemoteData()
            }
        } else {
            self.updateRemoteData()
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
