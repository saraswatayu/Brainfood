//
//  Error.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 1/29/17.
//  Copyright © 2017 SwatTech, LLC. All rights reserved.
//

import Foundation

enum InvalidURLError: Error {
    case invalidURL
}

enum InvalidJSONError: Error {
    case inputDataNil
    case missingParameters
}
