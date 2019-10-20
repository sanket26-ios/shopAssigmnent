//
//  CommonUIClass.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import Foundation
import UIKit

class CommonUIClass : NSObject {
    
    static func setDownwardShadowForView(view:UIView) {
        CommonUIClass.setShadowForView(view: view)
        DispatchQueue.main.async {
            view.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
    }
    
    static func setShadowForView(view:UIView) {
        DispatchQueue.main.async {
            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.15
            view.layer.shadowOffset = CGSize(width: 0, height: 1)
            view.layer.shadowRadius = 2
        }
    }
    
    static func getIndexOfCurrentlyVisibleCellOfCollectionView(collectionView : UICollectionView) -> IndexPath? {
        let visibleRect = CGRect(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)
    }
}
