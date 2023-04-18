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
//  ReqresDefaultLogger.swift
//  Reqres
//
//  Created by Jan Mísař on 02.08.16.
//
//

import Foundation

open class ReqresDefaultLogger: ReqresLogging {

    open var logLevel: LogLevel = .verbose

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }

    open func logVerbose(_ message: String) {
        logMessage(message)
    }

    open func logLight(_ message: String) {
        logMessage(message)
    }

    open func logError(_ message: String) {
        logMessage(message)
    }

    private func logMessage(_ message: String) {
        print("[" + dateFormatter.string(from: Date()) + "] " + message)
    }
}

open class ReqresDefaultNSLogger: ReqresLogging {

    open var logLevel: LogLevel = .verbose

    open func logVerbose(_ message: String) {
        NSLog(message)
    }

    open func logLight(_ message: String) {
        NSLog(message)
    }

    open func logError(_ message: String) {
        NSLog(message)
    }
}
