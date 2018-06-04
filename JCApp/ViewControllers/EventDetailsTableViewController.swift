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

class EventDetailsTableViewController: UITableViewController, RatingProtocol {
    
    var item: Event?
    var localComments: [Comment] = []
    var ratingValue : Int = 0
    var ratingComment : String?
    var ratingAuthor : String?
    
    let TABLE_HEIGHT : CGFloat = 600.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped))

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(UINib(nibName: "SpeakerCustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "SpeakerCustomCellTableViewCell")
        
        // Dynamic height row
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = self.TABLE_HEIGHT
        self.updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.localComments.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpeakerCustomCellTableViewCell", for: indexPath) as! SpeakerCustomCellTableViewCell

            cell.event = self.item

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            let item = self.localComments[indexPath.row] // -1 row speaker

            cell.textLabel?.text = "\(item.author ?? "O Timido") - Nota: \(item.rate ?? 1)"
            cell.detailTextLabel?.text = item.comment

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let cell = self.tableView.cellForRow(at: indexPath) {
                return cell.frame.height
            }
            else {
                return TABLE_HEIGHT
            }
        } else {
            return UITableViewAutomaticDimension
        }
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
            self.alertMessage(title: "Erro", message: errorMessage, dismiss: false)
        }
    }
    
    func popUpRating() {
        let view = RatingViewController(nibName: "RatingViewController", bundle: nil)
        view.delegate = self
        
        let popup = PopupDialog(viewController: view, buttonAlignment: .vertical, transitionStyle: .bounceUp, preferredWidth: 340, gestureDismissal: true, hideStatusBar: false, completion: nil)
        
        // Create buttons
        let cancelButton = CancelButton(title: "Cancelar") {
        }
        
        let ratingButton = DefaultButton(title: "Avaliar", height: 60) {
            if self.ratingAuthor == "" {
                self.ratingAuthor = "Alguém Tímido"
            }
            
            var comment = Comment()
            //comment.author = self.
            comment.eventId = self.item?.eventId
            comment.rate = self.ratingValue
            comment.comment = self.ratingComment
            comment.author = self.ratingAuthor
            
            guard self.ratingValue > 0 else {
                self.alertMessage(title: "Erro", message: "Informe uma nota, utilize as estrelas", dismiss: false)
                return
            }
            
            comment.createComment(completeCall: { (returnComment) in
                if returnComment != nil {
                    self.updateData()
                }
            }, errorCall: { (errorMessage) in
                self.alertMessage(title: "Erro", message: errorMessage, dismiss: false)
            })
        }
        
        popup.addButtons([cancelButton, ratingButton])
        
        
        self.present(popup, animated: true, completion: nil)
    }
    
    // MARK: @OBJC Methods
    @objc func addTapped() {
        self.popUpRating()
    }
    
    // MARK: RateProtocol
    
    func rateEvent(numberStars: Int, comment: String?, author: String? ) {
        self.ratingValue = numberStars
        self.ratingComment = comment
        self.ratingAuthor = author
    }
}
