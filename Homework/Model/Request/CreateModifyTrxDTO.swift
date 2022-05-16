//
//  CreateModifyTrxDTO.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import Foundation

struct CreateModifyTrxDTO: Codable {
    var time: Int
    var title, description: String
    var details: [CreateModifyTrxDetailDTO]?
}

struct CreateModifyTrxDetailDTO: Codable {
    var name: String
    var quantity, price: Int
}
