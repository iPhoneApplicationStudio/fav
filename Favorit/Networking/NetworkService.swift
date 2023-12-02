//
//  NetworkService.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Alamofire

final class NetworkService {
    
    lazy private(set) var jsonDecoder = JSONDecoder()
    
    lazy private(set) var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 120
        return Session(configuration: configuration, eventMonitors: [AFLogger()])
    }()
    
    
    func fetch <T: Decodable>(apiEndPoint: APIEndpoint, 
                              model: T.Type,
                              isCustom: Bool = false,
                              completion: @escaping (Result<T, APIError>) -> Void) {
        
        self.request(
            apiEndPoint: apiEndPoint,
            model: model,
            isCustom: isCustom,
            completion: completion)
    }
    
    private func request <T: Decodable>(
        apiEndPoint: APIEndpoint,
        model: T.Type,
        isCustom: Bool,
        completion: @escaping (Result<T, APIError>) -> Void) {
            
            session.makeRequest(
                apiEndPoint.urlString,
                method: apiEndPoint.httpMethod,
                parameters: apiEndPoint.parameters,
                encoder: apiEndPoint.paramenterEncoding,
                headers: apiEndPoint.headers)
            .response { response in
                
                switch response.result {
                case .success(let data):
                    let result: Result<T, APIError> = self.parse(isCustom: isCustom, data: data)
                    switch result {
                    case .success(let decodedObject):
                        completion(.success(decodedObject))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    completion(.failure(.requestFailure(error: error)))
                }
            }
    }
    
    func parse<T: Decodable>(isCustom: Bool, data: Data?) -> Result<T, APIError> {
        
        guard let data = data else {
            return .failure(.noData)
        }
        
        do {
            if isCustom, let resp = try? jsonDecoder.decode(T.self, from: data) {
                return .success(resp)
            }
            
            let response = try jsonDecoder.decode(APIResponse<T>.self, from: data)
            
            if response.success?.bool == true, let data = response.data {
                return .success(data)
            }
            
            let message = response.message?.string ?? "Valid JSON but no error message received."
            return .failure(.domainError(message: message))
        } catch {
            return .failure(.unableToDecode(decodingError: error))
        }
    }
}

extension Session {
    public func makeRequest(
        _ convertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Encodable?,
        encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
        headers: HTTPHeaders? = nil) -> DataRequest {
            
            let request: DataRequest
            
            if parameters == nil {
                request = self.request(
                    convertible,
                    method: method,
                    headers: headers)
            } else {
                request = self.request(
                    convertible,
                    method: method,
                    parameters: parameters!,
                    encoder: encoder,
                    headers: headers)
            }
            
            
            return request
        }
}
