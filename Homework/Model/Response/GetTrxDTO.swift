//
//  GetTrxDTO.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import Foundation

struct GetTrxDTO: Codable {
    let id, time: Int
    let title, description: String
    let details: [GetTrxDetailDTO]?
}

struct GetTrxDetailDTO: Codable {
    let name: String
    let quantity, price: Int
}
