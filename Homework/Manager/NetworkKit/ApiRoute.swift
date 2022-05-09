//
//  ApiRoute.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import Foundation
import Alamofire

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}


/**
 根據不同的 domain / 需求 寫不同的 Router,
 可以依照不同的 host / DOMAIN / target 來劃分
*/
enum APIRouter: URLRequestConvertible {
    
    case getAll
    case add(requestBody: CreateModifyTrxDTO)
    case edit(transactionId: Int, requestBody: CreateModifyTrxDTO)
    case delete(transactionId: Int)
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try APIManager.host.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
                
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getAll:
            return .get
        case .add:
            return .post
        case .edit:
            return .put
        case .delete:
            return .delete
        }
    }
    
    // MARK: - Path, The path is the part following the base url
    private var path: String {
        switch self {
        case .getAll, .add:
            return APIManager.transaction
        case .edit(let id, _):
            return APIManager.transaction + "/\(id)"
        case .delete(let id):
            return APIManager.transaction + "/\(id)"
        }
    }
    
    // MARK: - Query Parameters
    private var parameters: Parameters? {
        switch self {
        case .getAll:
            return nil
        case .add(let body):
            guard let body = body.dictionary else {
                return nil
            }
            return body
        case .edit(_, let body):
            guard let body = body.dictionary else {
                return nil
            }
            return body
        case .delete(_):
            return nil
        }
    }
    
}

