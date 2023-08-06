//
//  Models.swift
//  
//
//  Created by Andriy Gordiyenko on 8/5/23.
//

import Foundation

enum AppealCodingError: Error {
    case decodingError(String)
}

struct FeatureImage: Codable, Equatable {
    let id: String
    let data: Data
}

struct FeaturesContainer: Codable, Identifiable, Equatable {

    let features: [Feature]
    var images: [FeatureImage]
    var releaseId: String?
    
    var id: String { return releaseId ?? "no-id" }

    private enum StoreKeys: String, CodingKey {
        case documents
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StoreKeys.self)
        features = try container.decode([Feature].self, forKey: .documents).sorted(by: { $0.order < $1.order })
        images = []
    }
    
}

struct Feature: Codable, Identifiable, Equatable {
    
    let id: String
    
    let title: String
    let body: String
    let imageUrl: String
    let order: Int
    var hearts: Int
    var heartsDebug: Int
    
    private enum StoreKeys: String, CodingKey {
        case name
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case title
        case body
        case imageUrl
        case order
        case hearts
        case heartsDebug
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: StoreKeys.self)
        
        let path = try? container.decode(String.self, forKey: .name)
        let pathComponents = path?.components(separatedBy: "/")
        if let id = pathComponents?.last {
            self.id = id
        } else {
            throw AppealCodingError.decodingError("Couldn’t find Feature ID")
        }
        
        let fieldsContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        title = try fieldsContainer.decode(StringValuePayload.self, forKey: .title).value
        body = try fieldsContainer.decode(StringValuePayload.self, forKey: .body).value
        imageUrl = try fieldsContainer.decode(StringValuePayload.self, forKey: .imageUrl).value
        
        let orderValue = try fieldsContainer.decode(IntegerValuePayload.self, forKey: .order).value
        if let int = Int(orderValue) {
            order = int
        } else {
            order = 0
        }
        
        let heartsValue = try fieldsContainer.decode(IntegerValuePayload.self, forKey: .hearts).value
        if let int = Int(heartsValue) {
            hearts = int
        } else {
            hearts = 0
        }
        
        let heartsDebugValue = try fieldsContainer.decode(IntegerValuePayload.self, forKey: .heartsDebug).value
        if let int = Int(heartsDebugValue) {
            heartsDebug = int
        } else {
            heartsDebug = 0
        }
    }
}

struct ReleasesContainer: Codable {
    
    let releases: [Release]
    
    private enum StoreKeys: String, CodingKey {
        case documents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StoreKeys.self)
        releases = try container.decode([Release].self, forKey: .documents)
    }
}

struct Release: Codable, Identifiable {
    
    let id: String
    let version: Int
    
    private enum StoreKeys: String, CodingKey {
        case name
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StoreKeys.self)
        let fieldsContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        let path = try? container.decode(String.self, forKey: .name)
        let pathComponents = path?.components(separatedBy: "/")
        if let id = pathComponents?.last {
            self.id = id
        } else {
            throw AppealCodingError.decodingError("Couldn’t find Release ID")
        }
        
        let versionValue = try fieldsContainer.decode(IntegerValuePayload.self, forKey: .version).value
        if let int = Int(versionValue) {
            version = int
        } else {
            version = 0
        }
    }
}
