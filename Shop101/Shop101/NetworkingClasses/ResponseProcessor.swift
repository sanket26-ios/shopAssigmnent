//
//  ResponseProcessor.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import Foundation

class ResponseProcessor {
    class func processDataModelFromGetURLRequest<T:Codable>(urlRequest : URLRequest, modalStruct:T.Type, responseProcessingBlock: @escaping ( T?, Error?) -> Void ) {
        
        ApiManager.defaultManager.get(request: urlRequest) { (data, response, error) in
            _ = response
            ResponseProcessor.processDataModalFromResponseData(modalStruct:T.self, data: data, urlRequest: urlRequest, error: error, responseProcessingBlock: responseProcessingBlock)
        }
    }
    
    class func processDataModelFromPostURLRequest<T:Codable>(urlRequest : URLRequest, modalStruct:T.Type, responseProcessingBlock: @escaping ( T?, Error?) -> Void ) {
        
        ApiManager.defaultManager.post(request: urlRequest) { (data, response, error) in
            _ = response
            ResponseProcessor.processDataModalFromResponseData(modalStruct:T.self, data: data, urlRequest: urlRequest, error: error, responseProcessingBlock: responseProcessingBlock)
        }
    }
    
    private class func processDataModalFromResponseData<T:Codable>(modalStruct:T.Type, data:Data?, urlRequest : URLRequest, error:Error?, responseProcessingBlock: @escaping ( T?, Error?) -> Void) {
        if let responseError = error {
            responseProcessingBlock(nil, responseError)
            return
        }
        
        if let responseData = data {
            let jsonDecoder = JSONDecoder.init()
            do {
                //let json = try JSONSerialization.jsonObject(with: responseData, options: []) // To check JSON DATA
                let modal = try jsonDecoder.decode(modalStruct.self, from: responseData)
                let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                if let dictionary = json as? [String: Any] {
                    if let Code = dictionary["code"] as? Int {
                        if Code == 419 || Code == 404 {
                            DispatchQueue.main.sync {
                                //Refresh Token
                                //NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
                                return
                            }
                        }
                    }
                    
                }
                responseProcessingBlock(modal, nil)
                
            } catch let parsingError {
                responseProcessingBlock(nil, parsingError)
            }
        }
        
    }
}
