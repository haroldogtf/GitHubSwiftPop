//
//  APIConnection.swift
//  DesafioConcrete
//
//  Created by Haroldo Gondim on 26/01/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class APIConnection: NSObject {
    
    class func getGitHubRepositories(page: Int, completion: @escaping (_ result: [Repository]?, _ error: Error?) -> ()) {
        
        print(page)
        let url =  "https://api.github.com/search/repositories?q=language:Swift&sort=stars&page=\(page)"
        
        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<RepositoryResponse>) in
            completion(response.result.value?.repository, response.error)
        }
    }
    
    class func getPullResquestsFrom(repository: String, page: Int, completion: @escaping (_ result: [PullResquest]?, _ error: Error?) -> ()) {
        
        let url =  "https://api.github.com/repos/\(repository)/pulls?page=\(page)"
        
        Alamofire.request(url, method: .get).responseArray { (response: DataResponse<[PullResquest]>) in
            completion(response.result.value, response.error)
        }
    }

}
