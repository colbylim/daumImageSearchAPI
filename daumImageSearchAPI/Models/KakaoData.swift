//
//  KakaoData.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Foundation

struct KakaoData: Codable {
    
    let documents: [Document]
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case documents
        case meta
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        documents = try values.decode([Document].self, forKey: .documents)
        meta = try values.decode(Meta.self, forKey: .meta)
    }
}
