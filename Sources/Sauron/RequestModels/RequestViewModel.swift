//
//  RequestViewModel.swift
//  
//
//  Created by Duc Do on 20.4.2023.
//

import Foundation
import SwiftUI

struct RequestViewModel: Identifiable {
    var id: String
    var url: String
    var code: ResponseCode
    var duration: TimeInterval?

    var request: NetworkCall
    var response: NetworkCall

    init(requestModel: RequestModel) {
        self.id = requestModel.id
        self.url = requestModel.url
        self.code = ResponseCode(code: requestModel.code)
        self.duration = requestModel.duration
        self.request = NetworkCall(headers: requestModel.headers, date: requestModel.date, body: requestModel.httpBody?.bodyString)
        var responseTimestamp = requestModel.date
        if let duration = duration {
            responseTimestamp = responseTimestamp.addingTimeInterval(duration)
        }

        self.response = NetworkCall(headers: requestModel.responseHeaders, date: responseTimestamp, body: requestModel.dataResponse?.bodyString)
    }
}

struct NetworkCall {
    var headers: [String: String]?
    var date: Date
    var body: String?
}

struct ResponseCode {
    var code: Int
    var type: Type {
        switch code {
            case 1...199:
                return .informational
            case 200...299:
                return .success
            case 300...399:
                return .redirection
            case 400...499:
                return .clientError
            case 500...599:
                return .serverError
            default:
                return .unknown

        }
    }

    enum `Type`: String, CaseIterable {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case unknown

        var backgroundColor: Color {
            switch self {
                case .informational:
                    return Color.blue
                case .success:
                    return Color.green
                case .redirection:
                    return Color.yellow
                case .clientError:
                    return Color.orange
                case .serverError:
                    return Color.red
                case .unknown:
                    return .gray
            }
        }
    }
}
