//
//  SHTabBarController.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import UIKit

class SHTabBarController: UITabBarController {
    
    let baseViewControllerXib = "BaseViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabBar()

    }
    
    func setTabBar() {
        self.tabBar.barTintColor = .white
        
        let firstVC = FirstViewController.init(nibName: baseViewControllerXib, bundle: nil)
        let secondVC = SecondViewController.init(nibName: baseViewControllerXib, bundle: nil)
        let thirdVC = ThirdViewController.init(nibName: baseViewControllerXib, bundle: nil)
        let fourthVC = FourthViewController.init(nibName: baseViewControllerXib, bundle: nil)
        
        
        let firstNavigation = UINavigationController.init(rootViewController: firstVC)
        firstNavigation.navigationBar.isHidden = true

        let secondNavigation = UINavigationController.init(rootViewController: secondVC)
        secondNavigation.navigationBar.isHidden = true

        let thirdNavigation = UINavigationController.init(rootViewController: thirdVC)
        thirdNavigation.navigationBar.isHidden = true

        let fourthNavigation = UINavigationController.init(rootViewController: fourthVC)
        fourthNavigation.navigationBar.isHidden = true
        
        firstNavigation.tabBarItem?.title = "First"
        secondNavigation.tabBarItem?.title = "Second"
        thirdNavigation.tabBarItem?.title = "Third"
        fourthNavigation.tabBarItem?.title = "Fourth"
        
        let selectedImage = UIImage.init(named: "home_ic_selected")?.withRenderingMode(.alwaysOriginal)
        let unSelectedImage = UIImage.init(named: "home_ic")?.withRenderingMode(.alwaysOriginal)
        
        firstNavigation.tabBarItem.image = unSelectedImage
        firstNavigation.tabBarItem.selectedImage = selectedImage
        
        secondNavigation.tabBarItem.image = unSelectedImage
        secondNavigation.tabBarItem.selectedImage = selectedImage

        thirdNavigation.tabBarItem.image = unSelectedImage
        thirdNavigation.tabBarItem.selectedImage = selectedImage

        fourthNavigation.tabBarItem.image = unSelectedImage
        fourthNavigation.tabBarItem.selectedImage = selectedImage
        
        let viewControllerList = [firstNavigation, secondNavigation, thirdNavigation, fourthNavigation]
        self.viewControllers = viewControllerList

    }
    

}
