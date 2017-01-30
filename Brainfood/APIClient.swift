//
//  APIClient.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 1/29/17.
//  Copyright © 2017 SwatTech, LLC. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

import PromiseKit

struct APIClient {
    
    private let baseUrl = URL(string: "https://pbiprrk71j.execute-api.us-west-2.amazonaws.com/prod/purchase_function")
    
    func request() -> Promise<[FoodItem]> {
        guard let baseUrl = baseUrl else {
            return Promise(error: InvalidURLError.invalidURL)
        }
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return Promise { fulfill, reject in
            Alamofire.request(baseUrl, method: .get).responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let items = json.array?.flatMap { FoodItem(json: $0) }
                    
                    if let items = items {
                        fulfill(items)
                    } else {
                        reject(InvalidJSONError.inputDataNil)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func addFoodItem(item: FoodItem) -> Promise<Void> {
        guard let baseUrl = baseUrl else {
            return Promise(error: InvalidURLError.invalidURL)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        return Promise { fulfill, reject in
            Alamofire.request(baseUrl, method: .post, parameters: item.serialize()).response { response in
                if let error = response.error {
                    reject(error)
                } else {
                    fulfill()
                }
            }
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}
