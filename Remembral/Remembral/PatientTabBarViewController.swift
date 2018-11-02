//
//  PatientTabBarViewController.swift
//  Remembral
//
//  Created by Alwin Leong on 10/31/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit

class PatientTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
        rootView.popToRootViewController(animated: false)
    }

}
