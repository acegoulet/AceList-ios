//
//  Category.swift
//  AceList
//
//  Created by Ace Goulet on 8/30/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var dateCreated : Date = Date()
    @objc dynamic var dateModified : Date = Date()
    //link category to its items
    let items = List<Item>()
}
