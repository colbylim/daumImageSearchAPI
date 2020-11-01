//
//  Extension+Error.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var userInfo: [String: Any] { return (self as NSError).userInfo }
}
