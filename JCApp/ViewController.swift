//
//  ViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 22/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import JCApiClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let event = Event(title: "hello world")
        
        print(event.title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

