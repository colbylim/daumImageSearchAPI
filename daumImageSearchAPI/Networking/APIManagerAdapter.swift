//
//  APIManagerAdapter.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Alamofire

final class APIManagerAdapter: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.retryCount == 3 {
            completion(.doNotRetryWithError(error))
            return
        }
        
        if error.code == NSURLErrorTimedOut {
            completion(.retry)
        } else {
            completion(.doNotRetryWithError(error))
        }
    }
}

