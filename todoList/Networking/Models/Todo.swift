//
//  Todo.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import ObjectMapper

struct Todo: Mappable {
    var id: Int? = 0
    var userId: Int? = 0
    var title: String? = ""
    var completed: Bool? = false
    
    init?() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        userId <- map["userId"]
        title <- map["title"]
        completed <- map["completed"]
    }
}

