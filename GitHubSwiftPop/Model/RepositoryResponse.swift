//
//  Repository.swift
//  DesafioConcrete
//
//  Created by Haroldo Gondim on 26/01/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import ObjectMapper

class RepositoryResponse: Mappable {

    var totalCount: Int?
    var repository: [Repository]?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        totalCount <- map["total_count"]
        repository <- map["items"]
    }

}

class Repository: Mappable {

    var name: String?
    var fullName: String?
    var description: String?
    var stars: Int?
    var forks: Int?
    var owner: Owner?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["name"]
        fullName <- map["full_name"]
        description <- map["description"]
        stars <- map["stargazers_count"]
        forks <- map["forks_count"]
        owner <- map["owner"]
    }
    
}

class Owner: Mappable {
    
    var username: String?
    var userFullName: String?
    var photoURL: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        username <- map["login"]
        photoURL <- map["avatar_url"]
    }
    
}
