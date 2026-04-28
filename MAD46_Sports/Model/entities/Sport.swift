//
//  Sport.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 28/04/2026.
//

import Foundation

import Foundation

struct Sport: Decodable {
    let sportName: String?
    let sportThumb: String?
    
    enum CodingKeys: String, CodingKey {
        case sportName = "strSport"
        case sportThumb = "strSportThumb"
    }
}

struct SportResponse: Decodable {
    let result: [Sport]?
}
