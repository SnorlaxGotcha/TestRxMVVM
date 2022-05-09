//
//  CreateModifyTrxDTO.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import Foundation

struct CreateModifyTrxDTO: Codable {
    let time: Int
    let title, description: String
    let details: [CreateModifyTrxDetailDTO]?
}

struct CreateModifyTrxDetailDTO: Codable {
    let name: String
    let quantity, price: Int
}
