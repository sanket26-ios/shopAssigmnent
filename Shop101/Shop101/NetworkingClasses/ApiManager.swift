//
//  ApiManager.swift
//  Shop101
//
//  Created by sanket on 19/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import Foundation

//error Domain
let kApplicationErrorDomain = "com.shop101.error"

public enum ParameterEncoding {
    case JSON //Get Request
    case BODY //Post Request
}

class ApiManager {
    var pendingTasks:[PendingTask] = [PendingTask]()
    var isRefreshingToken:Bool = false
    var urlString:String? = ""
    var errorMessage:String? = ""
    var httpStatusCode:Int?
    
    static let defaultManager = ApiManager()
    
    func post(request:URLRequest, completion:@escaping RequestCompletionBlock) {
        createDataTask(withRequest:request, httpMethod: "POST", completion: completion)
    }


    func get(request:URLRequest, completion:@escaping RequestCompletionBlock) {
        createDataTask(withRequest:request, httpMethod: "GET", completion: completion)
    }
    
    var commonHeaders:[String:String] {
        var commonHeaders = [String:String]()
//        commonHeaders["device"] = "phone"
        commonHeaders["X-Auth-Token"] = "0Zxr/7HeCorA90t4trv9JQ=="
        return commonHeaders
    }
    
    lazy var excludeAPIForCommonHeaders:[String] = {
        var excludeAPIForCommonHeaders = [String]()
        excludeAPIForCommonHeaders.append("/dictionary/dictionary.json")
        return excludeAPIForCommonHeaders
    }()
    
    private func getRequest(forPath path:String) -> URLRequest {
        return URLRequest(url: URL(string: path)!)
    }
        
    
    func prepareRequest(path:String, params: [String: Any]? = nil, encoding:ParameterEncoding) -> URLRequest {
        var request:URLRequest?
        if let params = params {
            switch encoding {
            case .JSON:
                //JSON
                request = getRequest(forPath: path)
                do {
                    let jsonData:Data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                    request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request?.httpBody = jsonData
                    request?.httpMethod = "GET"
                } catch {
                    print(error)
                }
                
            case .BODY:
                //POST BODY
                request = getRequest(forPath: path)
                var paramString:String = ""
                for (key, value) in params {
                    guard let escapedKey:String = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        else { fatalError("Key should be of type string") }
                    var escapedValue:String?
                    if let valueAsString:String = value as? String {
                        escapedValue = valueAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    } else {
                        escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    }
                    
                    paramString = paramString + escapedKey + "=" + escapedValue! + "&"
                }
                request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request?.setValue("no-cache", forHTTPHeaderField: "cache-control")
                let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
                request?.httpBody = jsonData//paramString.data(using: String.Encoding.utf8)
                request?.httpMethod = "POST"
            }
        } else {
            request = getRequest(forPath: path)
        }
        
        if excludeAPIForCommonHeaders.contains(path) == false {
            request?.allHTTPHeaderFields = commonHeaders //Common Headers to be set with Each API call
        }
        
        return request!
    }
    
    
    private func createDataTask(withRequest request:URLRequest, httpMethod method:String, completion:@escaping RequestCompletionBlock) {
        var originalRequest = request
        originalRequest.httpMethod = method
        originalRequest.timeoutInterval = 30.0
        //Create a datatask with new completion handler
        let dataTask = URLSession.shared.dataTask(with: originalRequest) {(data, response, error) in
            if let responseError = error {
                //TODOs: Manual Exception Handling
                completion(nil, nil, responseError)
                return
            }
            //This is a new completion handler
            guard let httpResponse:HTTPURLResponse = response as? HTTPURLResponse else {
                //TODOs: Add Manual exception tracking,No Internet Connection
                var errorInfo:[String:String] = [String:String]()
                errorInfo[NSLocalizedDescriptionKey] = "Failed to get response from server."
                completion(nil, nil, NSError(domain: kApplicationErrorDomain, code: 101, userInfo: errorInfo))
                //JMActivityView.shared.hideProgressView()
                return
            }
            self.httpStatusCode = httpResponse.statusCode
            print(httpResponse.statusCode)
            
            //This condition is added to simulate refresh toke scenario
            
            switch self.httpStatusCode {
            case 419, 400 :
                if ApiManager.defaultManager.isRefreshingToken == false {
                    //Put the currentTask in queue
                    let currentTask:PendingTask = PendingTask()
                    currentTask.request = originalRequest
                    currentTask.completionHandler = completion
                    ApiManager.defaultManager.pendingTasks.append(currentTask)
                    //Update the flag so that other requests will start coming in queue
                    
                    ApiManager.defaultManager.isRefreshingToken = true
                    DispatchQueue.global().async(execute: {
                        DispatchQueue.main.sync {
                            // Post Notification and observe and refresh The token
                            //NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
                        }
                        self.pendingTasks.removeAll()
                        ApiManager.defaultManager.isRefreshingToken = false
                    })
                } else {
                    //Token refresh is in progres put the task in queue to finish later
                    let pendingTask:PendingTask = PendingTask()
                    pendingTask.request = originalRequest
                    pendingTask.completionHandler = completion
                    ApiManager.defaultManager.pendingTasks.append(pendingTask)
                }
            case 504 :
                var errorInfo:[String:String] = [String:String]()
                self.errorMessage = "Server Timeout : Please try again in some time"
                errorInfo[NSLocalizedDescriptionKey] = self.errorMessage
                completion(nil, nil, NSError(domain: kApplicationErrorDomain, code: 504, userInfo: errorInfo))
            case 200, 204 :
                
                completion(data, response, error)
            default:
                var errorInfo:[String:String] = [String:String]()
                let errorDescription = "Unexpected Response : HTTP Status Code :\(String(describing: self.httpStatusCode))"
                if let receivedData = data {
                    let responseString = String(data:receivedData, encoding:.utf8)
                    self.errorMessage = errorDescription + " " + responseString!
                }
                errorInfo[NSLocalizedDescriptionKey] = self.errorMessage
                completion(nil, nil, NSError(domain: kApplicationErrorDomain, code: self.httpStatusCode!, userInfo: errorInfo))
            }
        }
        dataTask.resume()
    }
    
}
