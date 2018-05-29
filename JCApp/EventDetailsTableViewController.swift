//
//  EventDetailsTableViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 29/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import JCApiClient
import PopupDialog

class EventDetailsTableViewController: UITableViewController {

    var item: Event?
    var localComments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped))
        
        self.updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localComments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = self.localComments[indexPath.row]
        
        cell.textLabel?.text = item.author
        cell.detailTextLabel?.text = item.comment
        
        return cell
    }

    // MARK: IBActions
    @IBAction func updateCommentsAction(_ sender: Any) {
        self.updateData()
    }

    // MARK: Local Methods
    func updateData() {
        self.tableView.refreshControl?.beginRefreshing()
        Comment.getCommentsFromEvent(event: self.item, completeCall: { (returnData) in
            if let returnData = returnData {
                self.localComments = returnData
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }) { (errorMessage) in
            print(errorMessage)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func popUpRating() {
        let view = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        let popup = PopupDialog(viewController: view, buttonAlignment: .vertical, transitionStyle: .bounceUp, preferredWidth: 340, gestureDismissal: true, hideStatusBar: false, completion: nil)
        
        // Create buttons
        let cancelButton = CancelButton(title: "Cancelar") {
        }
        
        let ratingButton = DefaultButton(title: "Avaliar", height: 60) {
            // TODO: Rate
        }
        
        popup.addButtons([cancelButton, ratingButton])
        
        
        self.present(popup, animated: true, completion: nil)
    }
    
    // MARK: @OBJC Methods
    @objc func addTapped() {
        self.popUpRating()
    }
    
}
