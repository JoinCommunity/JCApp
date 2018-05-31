//
//  EventsTableViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 22/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import JCApiClient

class EventsTableViewController: UITableViewController, UISearchBarDelegate, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var localSearchBar: UISearchBar!
    
    var localArray: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config SearchBar
        self.localSearchBar.delegate = self
        
        // Color
        if #available(iOS 11.0, *) {
            // Large titles
            self.navigationController?.navigationBar.prefersLargeTitles = true
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
        self.tableView.separatorStyle = .none
        
        // Dynamic height row
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130.0
        
        // Get remote data
        self.updateLocalData()
        
        // Custom ui search bar
        self.localSearchBar.backgroundColor = UIColor.white
        self.localSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        for view in self.localSearchBar.subviews.first!.subviews {
            view.backgroundColor = UIColor.clear
            if view.isKind(of: UITextField.self) {
                let textField = view as! UITextField
                textField.layer.borderWidth = 2.0
                textField.layer.borderColor = UIColor.backGroundColor.cgColor
                textField.layer.cornerRadius = 18.0
                textField.font = UIFont(name: "Open Sans Regular", size: 17.0)
                //textField.textColor = UIColor.fixarTitleBlueColor
                textField.backgroundColor = UIColor.clear
            }
        }
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
        cell.nameLabel.text = item.name?.capitalized
        cell.roomLabel.text = item.room
        cell.speakerLabel.text = item.speaker
        cell.timeLabel.text = item.schedule
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.localArray[indexPath.row] as Event
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailsTableViewController") as? EventDetailsTableViewController else {
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
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SpeakerDetailsViewController") as? SpeakerDetailsViewController else {
            return nil
        }
        
        viewController.item = item
        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            Event.searchEvents(terms: searchText, completeCall: { (returnEntity) in
                if let returnEntity = returnEntity {
                    self.localArray = returnEntity
                    self.tableView.reloadData()
                }
            }) { (errorMessage) in
                print(errorMessage)
            }
        }
        else {
            self.updateLocalData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
