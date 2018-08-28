//
//  Item.swift
//  AceList
//
//  Created by Ace Goulet on 8/28/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import Foundation

class Item {
    
    var title: String = ""
    var done: Bool = false
    
    init(itemTitle: String, itemDone: Bool){
        title = itemTitle
        done = itemDone
    }
    
}
