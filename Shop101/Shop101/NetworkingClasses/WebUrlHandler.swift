//
//  WebUrlHandler.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import Foundation
class WebUrlHandler {
    static let baseUrl = ""
    
    class func getFirstControllerUrl(paginationKey: Int) -> String {
        return "https://www.zyxw365.in/O1Server/v1/stores/8406005976/supplyTileFeed/all?limit=5&paginationKey=\(paginationKey)&clientLocalOffset=0&cleanPagination=true"
    }    
}
