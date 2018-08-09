//
//  ViewController.swift
//  PushNotificationAppleDMT
//
//  Created by Buzoianu Stefan on 06/08/2018.
//  Copyright © 2018 Buzoianu Stefan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self,selector: #selector(catchNotification),name: appDelegate.receivedNotification,object: nil)
        
    }

    @objc func catchNotification() {
        print("Catch notification")
        self.view.backgroundColor = UIColor.red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

