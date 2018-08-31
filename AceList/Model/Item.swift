//
//  Item.swift
//  AceList
//
//  Created by Ace Goulet on 8/30/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    @objc dynamic var dateModified : Date = Date()
    @objc dynamic var backgroundColor : String = "#FFFFFF"
    //link items to category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
