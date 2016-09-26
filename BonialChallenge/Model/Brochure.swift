//
//  Brochure.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 26.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import Foundation

class Brochure {
    
    let id: UInt
    let coverUrl: URL?
    let title: String
    let retailerName: String
    
    init(id: UInt, urlString: String?, title: String?, retailerName: String?) {
        self.id = id
        if urlString != nil {
            self.coverUrl = URL(string: urlString!)
        } else {
            self.coverUrl = nil
        }
        self.title = title ?? ""
        self.retailerName = retailerName ?? ""
    }
}
