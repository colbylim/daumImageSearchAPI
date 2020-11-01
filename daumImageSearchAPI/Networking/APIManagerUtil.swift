//
//  APIManagerUtil.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Alamofire

struct APIManagerUtil {
    
    static let shared: APIManagerUtil = APIManagerUtil()
    
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5
        
        let session = Session(configuration: configuration,
                              interceptor: APIManagerAdapter())
        
        return session
    }()
    
    private init() { }
}
