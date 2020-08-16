//
//  ResponseData.swift
//  geocode-list
//
//  Created by 新井まりな on 2020/08/16.
//  Copyright © 2020 Marina Arai. All rights reserved.
//

import Foundation

struct Area{
    var name: String = ""
    var lat: String = ""
    var long: String = ""
}

extension Area{
    init(_ json: [String: Any]){
        if let name = json["Name"] as? String {
            self.name = name
        }
        
        if let geometry = json["Geometry"] as? [String: Any]{
            if let coordinates = geometry["Coordinates"] as? String{
                let c:[String] = coordinates.components(separatedBy: ",")
                self.lat = c[0]
                self.long = c[1]
            }
        }
    }
}
