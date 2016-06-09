//
//  BaseNetworkCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/21/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class BaseNetworkCall {
    var method = "GET"
    var scheme = "https"
    var host = "glacial-brushlands-22982.herokuapp.com"
    var endpoint = ""
    var baseRoute = "api"
    var task: NSURLSessionTask?
    var data: NSData?
    var mutableRequest: NSMutableURLRequest! {
        get {
            let _mutableRequest = NSMutableURLRequest(URL: url()!)
            _mutableRequest.HTTPMethod = method
            _mutableRequest.addValue("application/vnd.api+json", forHTTPHeaderField: "Content-type")
            
            if method != "GET" {
                _mutableRequest.HTTPBody = data
            }
            
            return _mutableRequest
        }
    }
    
    func url() -> NSURL? {
        return NSURL(string: scheme + "://" + host + "/" + baseRoute + "/" + endpoint)
    }
    
    func executeWithCompletionBlock(completion: (NSDictionary?, NSError?) -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        task = session.dataTaskWithRequest(mutableRequest, completionHandler: { (data, response, optError) in
            dispatch_async(dispatch_get_main_queue(), {
                if optError?.code != -999 {
                    if let error = optError {
                        print(String(error.debugDescription))
                        UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                    }
                    if let code = (response as? NSHTTPURLResponse)?.statusCode {
                        if code < 300 {
                            if let jsonData = data {
                                do {
                                    let dict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? NSDictionary
                                    if let jsonDict = dict {
                                        completion(jsonDict, nil)
                                    }
                                }catch let jsonError as NSError {
                                    completion(nil, jsonError)
                                }
                            }else{
                                completion(nil, optError)
                            }
                        }else{
                            print(self.endpoint + " " + String(code))
                            completion(nil, optError)
                        }
                    }
                }
            });
        })
        task?.resume()
    }
}
