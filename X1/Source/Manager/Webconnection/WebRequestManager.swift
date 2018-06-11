//
//  WebRequestManager.swift
//  indeclap
//
//  Created by Huulke on 12/14/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit
import Alamofire

class WebRequestManager: NSObject {
    
    var lastRequest:DataRequest?
    
    func httpRequest(method type:HTTPFunction, apiURL url:String, body parameters:Dictionary<String,Any>, completion success:@escaping(_ response:Dictionary<String, Any>) -> Void, failure errorOccured:@escaping (_ error:String) ->Void ) {
        let requestURL = URL.init(string: url)
        let httpMethod = HTTPMethod.init(rawValue: type.rawValue)!
        print("API Request with URL: \(requestURL!.absoluteString) and Parameters: \(parameters)")
       lastRequest =  Alamofire.request(requestURL!, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("Response \(response)")
            switch response.result {
            case .success:
                if let responseBody = response.result.value as? Dictionary<String,Any> {
                    // API request complete with response
                    success(responseBody)
                }
            case .failure(let error):
                // API Request failed with error
                print("Error occured in API Request: \(url) --> Error Description \(error.localizedDescription)")
                errorOccured(error.localizedDescription)
            }
        }
    }
    
    func httpRequest(method type:HTTPFunction, apiURL url:String, httpHeader header:Dictionary<String,String>,  body parameters:Dictionary<String,Any>, completion success:@escaping(_ response:Dictionary<String, Any>) -> Void, failure errorOccured:@escaping (_ error:String) ->Void ) {
        // API Request
        let requestURL = URL.init(string: url)
        let httpMethod = HTTPMethod.init(rawValue: type.rawValue)!
        print("API Request with URL: \(url ) and Parameters: \(parameters) and headers: \(header)")
        Alamofire.request(requestURL!, method: httpMethod, parameters: parameters, encoding:URLEncoding.httpBody, headers:header).responseJSON { (response) in
            print("Response \(response)")
            switch response.result {
            case .success:
                if let responseBody = response.result.value as? Dictionary<String,Any> {
                    // API request complete with response
                    success(responseBody)
                }
            case .failure(let error):
                // API Request failed with error
                print("Error occured in API Request: \(url) --> Error Description \(error.localizedDescription)")
                errorOccured(error.localizedDescription)
            }
        }
    }
    
    func uploadImage(htttpMethod method:HTTPFunction, apiURL url:String, parameters:Dictionary<String,Any>, image:UIImage?, completion success:@escaping(_ response:Dictionary<String, Any>) -> Void, failure errorOccured:@escaping (_ error:String) ->Void ) {
        // Upload user image with access token in
        let httpMethod = HTTPMethod.init(rawValue: method.rawValue)!
        var imageData:Data?
        if let postImage = image {
            imageData = postImage.compressTo(500) // Compress to 500 KB in
        }
        print("API URL: \(url) with parameters :\(parameters)")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let imageData = imageData, imageData.count > 0 {
                    multipartFormData.append(imageData, withName: "file", fileName: "picture.jpg", mimeType: "image/jpg")
                }
                for (key,value) in parameters {
                    if let parameter = "\(value)".data(using: .utf8) {
                        multipartFormData.append(parameter, withName: key)
                    }
                }
        },
            to: url, method: httpMethod,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success:
                            if let responseBody = response.result.value as? Dictionary<String,Any> {
                                // API request complete with response
                                print("Image uploaded with response \(responseBody)")
                                success(responseBody)
                            }
                        case .failure(let error):
                            print("API Failure for image upload \(error.localizedDescription)")
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    errorOccured(encodingError.localizedDescription)
                }
        }
        )
    }
    
    func cancelLastRequset() {
        lastRequest?.cancel()
    }
}

enum HTTPFunction: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}



