//
//  Category.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 26.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import Foundation

class Category {
    
    let id: UInt
    let urlString: String
    let name: String
    var brochures = [Brochure]()
    
    init(id: UInt, urlString: String?, name: String?) {
        self.id = id
        self.urlString = urlString ?? ""
        self.name = name ?? ""
    }
    
    func append(brochure: Brochure) {
        brochures.append(brochure)
    }
}
