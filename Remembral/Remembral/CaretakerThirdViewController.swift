//
//  CaretakerThirdViewController.swift
//  Remembral
//
//  Created by Alwin Leong on 11/2/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit

class CaretakerThirdViewController: ThirdViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseDatabase.sharedInstance.updateRemindersThen {
            (dict) in
            self.reminders = dict
            self.tableView.reloadData()
        }
    }
}
