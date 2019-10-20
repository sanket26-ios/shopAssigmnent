//
//  SplashViewController.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentTabBar()
    }
    
    func presentTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SHTabBarController")
        self.present(controller, animated: true, completion: nil)
    }

}
