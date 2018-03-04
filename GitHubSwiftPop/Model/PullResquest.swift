//
//  PullResquestResponse.swift
//  DesafioConcrete
//
//  Created by Haroldo Gondim on 26/01/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import ObjectMapper

class PullResquest: Mappable {

    var title: String?
    var body: String?
    var url: String?
    var user: User?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        title <- map["title"]
        body <- map["body"]
        url <- map["html_url"]
        user <- map["user"]
    }
        
}

class User: Mappable {
    
    var name: String?
    var photoURL: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["login"]
        photoURL <- map["avatar_url"]
    }
    
}
