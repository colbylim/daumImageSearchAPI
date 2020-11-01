//
//  Document.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Foundation

struct Document: Codable {
    
    let collection: String
    let thumbnailUrl: String
    let imageUrl: String
    let displaySitename: String
    let docUrl: String
    let dateTime: String
    let width: Int
    let height: Int
    
    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailUrl = "thumbnail_url"
        case imageUrl = "image_url"
        case displaySitename = "display_sitename"
        case docUrl = "doc_url"
        case dateTime = "datetime"
        case width
        case height
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        collection = try values.decode(String.self, forKey: .collection)
        thumbnailUrl = try values.decode(String.self, forKey: .thumbnailUrl)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
        displaySitename = try values.decode(String.self, forKey: .displaySitename)
        docUrl = try values.decode(String.self, forKey: .docUrl)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        dateTime = try values.decode(String.self, forKey: .dateTime)
    }
}
