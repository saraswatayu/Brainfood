//
//  FoodItem.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 1/29/17.
//  Copyright © 2017 SwatTech, LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FoodItem {
    
    let vendorID: String
    let itemDescription: String
    
    init?(json: JSON) {
        guard
            let vendorID = json["User"].string,
            let itemDescription = json["Item"].string
        else {
            return nil
        }
        
        self.vendorID = vendorID
        self.itemDescription = itemDescription
    }
    
    init(vendorID: String, itemDescription: String) {
        self.vendorID = vendorID
        self.itemDescription = itemDescription
    }
    
    func serialize() -> [String : Any] {
        return ["User" : vendorID, "Item" : itemDescription]
    }
    
}
