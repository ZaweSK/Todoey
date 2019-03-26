//
//  Item.swift
//  todoey
//
//  Created by Peter on 11/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc var dateCreated = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
