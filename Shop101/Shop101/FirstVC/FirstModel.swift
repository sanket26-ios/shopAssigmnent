//
//  FirstModel.swift
//  Shop101
//
//  Created by sanket on 20/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import Foundation

struct DetailModel : Codable {
    var paginationKey : Int?
    var catalogues : [ObjectModel]?
    
}

struct ObjectModel: Codable {
    var templateId : Int?
    var catalogueCoverUrl : String?
    var catalogueName : String?
    var title : String?
    var imageElements : [ImageElement]?
}

struct ImageElement : Codable {
    var imageUrl : String?
}
