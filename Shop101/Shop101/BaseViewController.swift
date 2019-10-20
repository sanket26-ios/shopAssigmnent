//
//  BaseViewController.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var customNavigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonUIClass.setDownwardShadowForView(view: customNavigationView)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    


}
