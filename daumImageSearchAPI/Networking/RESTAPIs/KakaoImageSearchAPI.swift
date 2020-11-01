//
//  KakaoImageSearchAPI.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Foundation

enum KakaoImageSearchAPI: KakaoRequestProtocol {
    
    typealias ResponseType = KakaoData
    
    case get(query: String, page: Int)
    
    var method: HttpMethod {
        switch self {
        case .get: return .get
        }
    }
    
    var path: String {
        return "https://dapi.kakao.com/v2/search/image"
    }

    var parameters: Params? {
        switch self {
        case let .get(query, page):
            return ["query": query,
                    "size": 30,
                    "page": page]
        }
    }
}
