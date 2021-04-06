//
//  Alamofire+Decodable.swift
//  iOS-Challenge
//
//  Created by Farshad Mousalou on 2/4/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil,
                                                     completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

}
