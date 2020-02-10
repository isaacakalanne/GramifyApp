//
//  NetworkProcessor.swift
//  Gramify
//
//  Created by Isaac Akalanne on 30/01/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation
import UIKit

class NetworkProcessor {
    
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    typealias JSONDictionaryHandler = (([String : Any]?) -> Void)
    
    func downloadJSONDictionary(fromURL url: URL, completion: @escaping JSONDictionaryHandler) {
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID ab89787499de1c4", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            do {
                                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                
                                completion(jsonDictionary as? [String : Any])
                                
                            } catch let error as NSError {
                                print(error.localizedDescription)
                            }
                        }
                    default:
                        print("HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
                
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
    
    func uploadImage(_ image : UIImage , withURL url : URL, completion: @escaping JSONDictionaryHandler) {
        
        let imageJPEGData = image.jpegData(compressionQuality: 1)
        let base64Data = imageJPEGData!.base64EncodedData(options: .lineLength64Characters)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("Client-ID ab89787499de1c4", forHTTPHeaderField: "Authorization")
        request.httpBody = base64Data
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            do {
                                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                completion(jsonDictionary as? [String : Any])
                                
                            } catch let error as NSError {
                                print(error.localizedDescription)
                            }
                        }
                    default:
                        print("HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
                
            }
            
        }
        
        dataTask.resume()
        
        
    }
    
}
