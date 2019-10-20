//
//  PendingTask.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import Foundation
import UIKit

typealias RequestCompletionBlock = (Data?, URLResponse?, Error?) -> Void

class PendingTask: NSObject {
    var request:URLRequest?
    var completionHandler:RequestCompletionBlock?
}
