//
//  Category.swift
//  todoey
//
//  Created by Peter on 11/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var categoryColor = ""
    
    var items = List<Item>()
}
