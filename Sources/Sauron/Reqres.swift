//
//Copyright (c) 2016 Jan Mísař <misar.jan@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
//  Reqres.swift
//  Reqres
//
//  Created by Jan Mísař on 05/27/2016.
//  Copyright (c) 2016 Jan Mísař. All rights reserved.
//
// swiftlint:disable_rule:cyclomatic_complexity

import Foundation

let ReqresRequestHandledKey = "ReqresRequestHandledKey"
let ReqresRequestTimeKey = "ReqresRequestTimeKey"

open class Reqres: URLProtocol, URLSessionDelegate {
    var dataTask: URLSessionDataTask?

    var currentRequest: RequestModel?

    public static var allowUTF8Emoji: Bool = true

    public static var logger: ReqresLogging = ReqresDefaultLogger()

    open class func register() {
        URLProtocol.registerClass(self)
    }

    open class func unregister() {
        URLProtocol.unregisterClass(self)
    }

    open class func defaultSessionConfiguration(
        additionalHeaders: [String: Any],
        timeoutIntervalForRequest: TimeInterval = 40,
        timeoutIntervalForResource: TimeInterval = 40,
        requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    ) -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.protocolClasses?.insert(Reqres.self, at: 0)
        config.httpAdditionalHeaders = additionalHeaders
        config.timeoutIntervalForRequest = timeoutIntervalForRequest
        config.timeoutIntervalForResource = timeoutIntervalForResource
        config.requestCachePolicy = requestCachePolicy
        return config
    }

    // MARK: - NSURLProtocol

    open override class func canInit(with request: URLRequest) -> Bool {
        guard self.property(forKey: ReqresRequestHandledKey, in: request) == nil && self.logger.logLevel != .none else {
            return false
        }
        return true
    }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    open override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }

    open override func startLoading() {
        guard let req = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest, currentRequest == nil else { return }

        currentRequest = RequestModel(request: request)
        Sauron.shared.insertRequest(currentRequest)
        URLProtocol.setProperty(true, forKey: ReqresRequestHandledKey, in: req)
        URLProtocol.setProperty(Date(), forKey: ReqresRequestTimeKey, in: req)

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            var duration: Double?
            if let startDate = URLProtocol.property(forKey: ReqresRequestTimeKey, in: req as URLRequest) as? Date {
                duration = fabs(startDate.timeIntervalSinceNow)
            }

            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
                self.currentRequest?.initError(error: error.localizedDescription, duration: duration)
                self.currentRequest?.logError()
                Sauron.shared.insertRequest(self.currentRequest)
                return
            }

            guard let response = response, let data = data else { return }

            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)

            self.currentRequest?.initResponse(response: response, duration: duration, data: data)
            self.currentRequest?.logResponse()
            Sauron.shared.insertRequest(self.currentRequest)
        }
        dataTask?.resume()

        guard let currentRequest = currentRequest else {
            /// This should never happen            
            return
        }

        currentRequest.logRequest()    
    }

    open override func stopLoading() {
        dataTask?.cancel()
    }    
}

extension URLRequest {
    var httpBodyData: Data? {

        guard let stream = httpBodyStream else {
            return httpBody
        }

        let data = NSMutableData()
        stream.open()
        let bufferSize = 4_096
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while stream.hasBytesAvailable {
            let bytesRead = stream.read(buffer, maxLength: bufferSize)
            if bytesRead > 0 {
                let readData = Data(bytes: UnsafePointer<UInt8>(buffer), count: bytesRead)
                data.append(readData)
            } else if bytesRead < 0 {
                print("error occured while reading HTTPBodyStream: \(bytesRead)")
            } else {
                break
            }
        }
        stream.close()
        return data as Data
    }
}
