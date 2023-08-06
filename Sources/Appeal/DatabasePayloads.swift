//
//  File.swift
//  
//
//  Created by Andriy Gordiyenko on 8/5/23.
//

import Foundation

struct IntegerValuePayload: Codable {
    let value: String
    private enum CodingKeys: String, CodingKey {
        case value = "integerValue"
    }
}

struct StringValuePayload: Codable {
    let value: String
    private enum CodingKeys: String, CodingKey {
        case value = "stringValue"
    }
}
