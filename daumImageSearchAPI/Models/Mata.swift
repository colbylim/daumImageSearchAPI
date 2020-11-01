//
//  Mata.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Foundation

struct Meta: Codable {
    
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        totalCount = try values.decode(Int.self, forKey: .totalCount)
        pageableCount = try values.decode(Int.self, forKey: .pageableCount)
        isEnd = try values.decode(Bool.self, forKey: .isEnd)
    }
}
