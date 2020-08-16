//
//  APIRequest.swift
//  geocode-list
//
//  Created by 新井まりな on 2020/08/16.
//  Copyright © 2020 Marina Arai. All rights reserved.
//

import Foundation
import UIKit

struct GeocorderAPI {
    
    static func fetchAddress(query: String,completion: @escaping ([Area]) -> Swift.Void){
        let endPoint: String = "https://map.yahooapis.jp/geocode/V1/geoCoder"
        let appId = "YOUR CLIANT ID"
        var query_str: String = query
        
        guard var urlComponents = URLComponents(string: endPoint) else { return }
        
        var params: [String: Any] = [
            "appid": appId,
            "output":"json",
            "query":query_str,
        ]
        
        let queryItems = params.map{ key, value -> URLQueryItem in
            return URLQueryItem(name: key, value: String(describing: value))
        }
        urlComponents.queryItems = queryItems
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!){ data, res, error in
            guard data != nil else{ return }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                guard let arr = json["Feature"] as? [Any] else { return }
                let areas = arr.compactMap{ $0 as? [String:Any]}.map{ Area($0)}
                completion(areas)
            } catch {
                print("Error:\(error)")
            }
        }
        
        task.resume()
    }
    
}
