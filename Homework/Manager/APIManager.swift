//
//  APIManager.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import Alamofire
import RxSwift

final class APIManager {

    static let host:String = "https://e-app-testing-z.herokuapp.com"
    static let transaction:String = "/transaction"
    
    static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<[T]> {
        return Observable<[T]>.create { observer in
            let request = AF.request(urlConvertible).responseJSON { response in

                switch response.result {
                case .success(_):
                    
                    guard let itemsData = response.data else {
                        observer.onError(ApiError.noData)
                        return
                    }
                                        
                    do {
                        let decoder = JSONDecoder()
                        let items = try decoder.decode([T].self, from: itemsData)
                        
                        observer.onNext(items)
                        observer.onCompleted()
                    } catch {
                        
                        /**
                         處理自定義錯誤
                         */
                        do {
                            let decoder = JSONDecoder()
                            let error = try decoder.decode(ErrorResponseDTO.self, from: itemsData)
                                                        
                            switch error.statusCode {
                            case 400:
                                observer.onError(ApiError.badrequest)
                            case 403:
                                observer.onError(ApiError.forbidden)
                            case 404:
                                observer.onError(ApiError.notFound)
                            case 500:
                                observer.onError(ApiError.internalServerError)
                            default:
                                observer.onError(ApiError.unknown)
                            }
                            
                        } catch {
                            observer.onError(error)
                        }
                        
                    }
                    
                /**
                 處理標準 HTTP status code
                 */
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }

            // Finally, return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
