//
//  ResponseSerializer.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 26.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import Foundation

typealias SerializationCompletion = ([Category]) -> ()
typealias SerializationFailure = (Error) -> ()

typealias JSON = [String: AnyObject]
typealias JSONArray = [JSON]

enum SerializationError: Error {
    case badResponse
    case wrongJSONFormat
    case noSectors
    case badCategoryValue
    case badCategoryId
    case badCategoryUrl
    case badCategoryName
    case noCategoryBrochures
    case badBrochureId
    case badBrochureCoverUrl
    case badBrochureTitle
    case badBrochureRetailerName
}

private let sectorsKey = "sectors"
// TODO: refactor - replace string constants

class ResponseSerializer {
    
    private let data: Data
    private let serializationQueue = OperationQueue()
    private var currentOperation: Operation?
    
    init(data: Data) {
        self.data = data
        serializationQueue.maxConcurrentOperationCount = 1
    }
    
    func serializeAsync(completion: @escaping SerializationCompletion, failure: SerializationFailure?) {
        currentOperation?.cancel()
        
        let operation = BlockOperation(block: {
            do {
                let categories = try self.serializeSync()
                DispatchQueue.main.async {
                    completion(categories)
                }
            } catch let error {
                failure?(error)
            }
        })
        serializationQueue.addOperation(operation)
        currentOperation = operation
    }
    
    func serializeSync() throws -> [Category] {
        var json: JSON
        do {
            if let results = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                json = results
            } else {
                throw SerializationError.wrongJSONFormat
            }
        } catch {
            debugPrint(error.localizedDescription)
            throw SerializationError.badResponse
        }
        
        guard let jsonCategories = json[sectorsKey] as? JSONArray else {
            throw SerializationError.noSectors
        }
        
        var categories = [Category]()
        for jsonCategory in jsonCategories {
            // Break for loop if opeartion is cancelled
            if currentOperation != nil && currentOperation!.isCancelled {
                break
            }
            let category = try serialize(category: jsonCategory)
            categories.append(category)
        }
        
        return categories
    }
    
    private func serialize(category jsonCategory: JSON) throws -> Category {
        guard let id = jsonCategory["id"] as? UInt else {
            throw SerializationError.badCategoryId
        }
        
        guard let urlString = jsonCategory["url"] as? String else {
            throw SerializationError.badCategoryUrl
        }
        
        guard let name = jsonCategory["name"] as? String else {
            throw SerializationError.badCategoryName
        }
        
        guard let jsonBrochures = jsonCategory["brochures"] as? JSONArray else {
            throw SerializationError.noCategoryBrochures
        }
        
        let category = Category(id: id, urlString: urlString, name: name)
        
        for jsonBrochure in jsonBrochures {
            // Break for loop if opeartion is cancelled
            if currentOperation != nil && currentOperation!.isCancelled {
                break
            }
            let brochure = try serialize(brochure: jsonBrochure)
            category.append(brochure: brochure)
        }
        
        return category
    }
    
    private func serialize(brochure jsonBrochure: JSON) throws -> Brochure {
        guard let id = jsonBrochure["id"] as? UInt else {
            throw SerializationError.badBrochureId
        }
        
        guard let urlString = jsonBrochure["coverUrl"] as? String else {
            throw SerializationError.badBrochureCoverUrl
        }
        
        guard let title = jsonBrochure["title"] as? String else {
            throw SerializationError.badBrochureTitle
        }
        
        guard let retailerName = jsonBrochure["retailerName"] as? String else {
            throw SerializationError.badBrochureRetailerName
        }
        
        let brochure = Brochure(id: id, urlString: urlString, title: title, retailerName: retailerName)
        
        return brochure
    }
    
    func cancel() {
        currentOperation?.cancel()
    }
}
