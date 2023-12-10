//
//  AFLogger.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Alamofire

final class AFLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "com.favorit.AFLogger")
    
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⌛️ Request Started: \(request)
        ⌛️ Request Body Data: \(body)
        """
        debugPrint(message)
    }
    
    func requestDidFinish(_ request: Request) {
        debugPrint(request.description)
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        guard response.data != nil else {
            return
        }
        debugPrint("⚡️ Response Received:")
        debugPrint(response.debugDescription as NSString)
        debugPrint("\n" as NSString)
    }
}
