//
//  ApiError.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import Foundation

enum ApiError: Error {
    case badrequest             //Status code 400
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    case wrapError
    case noData
    case unknown
}
