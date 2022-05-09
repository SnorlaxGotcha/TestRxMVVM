//
//  ErrorResponseDTO.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import Foundation

struct ErrorResponseDTO: Codable {
    let statusCode: Int
    let error: [String]?
    let message: String
}
