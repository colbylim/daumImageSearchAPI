//
//  APIProtocols.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Alamofire

typealias HttpMethod = HTTPMethod
typealias Params = Parameters

// MARK: - Base API Protocol
protocol BaseAPIProtocol {
    associatedtype ResponseType
    
    var method: HttpMethod { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
}

// MARK: - BaseRequestProtocol
protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    var parameters: Params? { get }
    var encoding: ParameterEncoding { get }
}

extension BaseRequestProtocol {
    
    var encoding: ParameterEncoding {
        if method == .get {
            return URLEncoding.default
        } else {
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: URL(string: path)!, method: method, headers: headers)
        urlRequest.timeoutInterval = TimeInterval(5)
        
        if let params = parameters {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
}

protocol KakaoRequestProtocol: BaseRequestProtocol {
    
}

extension KakaoRequestProtocol {
    var headers: HTTPHeaders? {
        return ["Authorization": "KakaoAK a1dcad1fa005aac7e95dbe54103d3e15"]
    }
}

