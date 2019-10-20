//
//  FirstViewModel.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import Foundation
class FirstViewModel {
    
    var reloadDataClosure: (() -> Void)?
    var paginationKey : Int?
    var productArray : [ObjectModel]? {
        didSet {
            if let reload = self.reloadDataClosure {
                reload()
            }
        }
    }
    
    func getDataForPaginationKey(paginationKey: Int) {
        let request = ApiManager.defaultManager.prepareRequest(path: WebUrlHandler.getFirstControllerUrl(paginationKey: paginationKey), encoding: .JSON)
        
        ResponseProcessor.processDataModelFromGetURLRequest(urlRequest: request, modalStruct: DetailModel.self) { (model, error) in
            if let data = model?.catalogues, self.paginationKey != model?.paginationKey {
                self.paginationKey = model?.paginationKey
                self.appendDataInProductArray(data: data)
            } else if error != nil{
                print(error as Any)
            }
        }
    }
    
    func appendDataInProductArray(data : [ObjectModel]) {
        if productArray == nil {
            productArray = data
        } else {
            productArray = (productArray ?? [ObjectModel]()) + data
        }
    }
    
    
    func getNextPagingData() {
        if let key = self.paginationKey {
            self.getDataForPaginationKey(paginationKey: key)
        }
    }
    
}
