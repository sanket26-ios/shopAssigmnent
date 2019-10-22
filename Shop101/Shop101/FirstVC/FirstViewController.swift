//
//  FirstViewController.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {
    let viewModel = FirstViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .lightGray
        self.registerCell()
        self.reloadClosureListner()
        self.viewModel.getDataForPaginationKey(paginationKey: -10000000)
        
    }
    
    func registerCell() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(UINib.init(nibName: ConstantClass.cellTemplateIdentifier, bundle: nil), forCellWithReuseIdentifier: ConstantClass.cellTemplateIdentifier)
    }
    
    
    func reloadClosureListner() {
         self.viewModel.reloadDataClosure = {
            if self.viewModel.productArray != nil {
                self.reloadCollectionView()
            }
        }
    }
    
}

extension FirstViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.productArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantClass.cellTemplateIdentifier, for: indexPath) as! TemplateCollectionViewCell
        if let data = viewModel.productArray?[indexPath.row] {
            cell.populateCellWithData(data: data)
        }
        return cell
    }
    
    
}

extension FirstViewController : UICollectionViewDelegate {
    
}

extension FirstViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.frame.width, height: 430)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let index = CommonUIClass.getIndexOfCurrentlyVisibleCellOfCollectionView(collectionView: self.collectionView), index.row >= (viewModel.productArray?.count ?? 0) - 3 {
            self.viewModel.getNextPagingData()
        }
    }
}
