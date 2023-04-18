//
//  RequestModel.swift
//  WhimNetwork
//
//  Created by Do Duc on 28/02/2019.
//

// From Wormholy-SDK-iOS by Paolo Musolino and Reqres by Jan Mísař

import Foundation

open class RequestModel: Codable, Equatable {
    public typealias Id = String

    public let id: Id
    public let url: String
    public let date: Date
    public let method: String
    public var headers: [String: String]?
    open var httpBody: Data?
    open var code: Int
    open var responseHeaders: [String: String]?
    open var dataResponse: Data?
    open var errorClientDescription: String?
    open var duration: Double?

    init(request: URLRequest) {
        id = UUID().uuidString
        url = request.url?.absoluteString ?? ""
        date = Date()
        method = request.httpMethod ?? "N/A"
        headers = request.allHTTPHeaderFields
        httpBody = request.httpBodyData
        code = 0
    }

    public func initResponse(response: URLResponse, duration: Double?, data: Data?) {
        guard let responseHttp = response as? HTTPURLResponse else { return }
        self.duration = duration
        code = responseHttp.statusCode
        responseHeaders = responseHttp.allHeaderFields as? [String: String]
        dataResponse = data
    }

    public func initError(error: String, duration: Double?) {
        self.duration = duration
        errorClientDescription = error
    }

    public func removeHeaders() {
        headers = [:]
        responseHeaders = [:]
    }

    public static func == (lhs: RequestModel, rhs: RequestModel) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Logging extensions
public extension RequestModel {
    var requestString: String {
        var s = "[Request ⬆️]: \(method) '\(url)'"

        s += "\n" + logHeaders(headers)

        s += "\nBody : \(logBody(httpBody))"

        return wrapInfoText(s)
    }

    var responseString: String {
        var s = "[Response ⬇️]: \(method) '\(url)'"

        s += code.statusLog

        if let duration = duration {
            s += String(format: " [time: %.5f s]", duration)
        }

        s += logHeaders(responseHeaders)

        s += "\nBody: \(logBody(dataResponse))"

        return wrapInfoText(s)
    }

    var errorString: String {
        var s = "[Response Error ⚠️]: \(method) '\(url)'"

        if let error = errorClientDescription {
            s += "ERROR: \(error)"
        }

        return wrapInfoText(s)
    }

    func logRequest() {
        logMessage(requestString)
    }

    func logResponse() {
        logMessage(responseString)
    }

    func logError() {
        logMessage(errorString)
    }

    private func logHeaders(_ headers: [String: String]?) -> String {
        guard let headers = headers, headers.count > 0 else { return "\n" }

        var s = "\nHeaders: [\n"

        headers.forEach({ s += "\t\($0.key) : \($0.value)\n" })

        s += "]"
        return s
    }

    private func logBody(_ body: Data?) -> String {
        guard let body = body else {
            return "Empty body 📭"
        }

        if let json = try? JSONSerialization.jsonObject(with: body, options: .mutableContainers),
            let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let string = String(data: pretty, encoding: String.Encoding.utf8) {
            return string
        }

        if let string = String(data: body, encoding: String.Encoding.utf8) {
            return string
        }

        return body.description
    }

    private func wrapInfoText(_ message: String) -> String {
        return "[" + DateLogFormatterHelper.shared.fulltimeString(from: date) + "] " + message
    }

    private func logMessage(_ message: String) {
        print(message)
    }
}

public extension Int {
    var statusLog: String {
        return "(\(statusIcon) \(self) \(statusString))"
    }

    var statusIcon: String {
        let iconNumber = Int(floor(Double(self) / 100.0))

        switch iconNumber {
        case 1: return "ℹ️"
        case 2: return "✅"
        case 3: return "⤴️"
        case 4: return "⛔️"
        case 5: return "❌"
        default: return "🤥"
        }
    }

    var statusString: String {
        switch self {
        case 100: return "Continue"
        case 101: return "Switching Protocols"
        case 102: return "Processing"
        case 200: return "OK"
        case 201: return "Created"
        case 202: return "Accepted"
        case 203: return "Non-Authoritative Information"
        case 204: return "No Content"
        case 205: return "Reset Content"
        case 206: return "Partial Content"
        case 207: return "Multi-Status"
        case 208: return "Already Reported"
        case 226: return "IM Used"
        case 300: return "Multiple Choices"
        case 301: return "Moved Permanently"
        case 302: return "Found"
        case 303: return "See Other"
        case 304: return "Not Modified"
        case 305: return "Use Proxy"
        case 306: return "Switch Proxy"
        case 307: return "Temporary Redirect"
        case 308: return "Permanent Redirect"
        case 400: return "Bad Request"
        case 401: return "Unauthorized"
        case 402: return "Payment Required"
        case 403: return "Forbidden"
        case 404: return "Not Found"
        case 405: return "Method Not Allowed"
        case 406: return "Not Acceptable"
        case 407: return "Proxy Authentication Required"
        case 408: return "Request Timeout"
        case 409: return "Conflict"
        case 410: return "Gone"
        case 411: return "Length Required"
        case 412: return "Precondition Failed"
        case 413: return "Request Entity Too Large"
        case 414: return "Request-URI Too Long"
        case 415: return "Unsupported Media Type"
        case 416: return "Requested Range Not Satisfiable"
        case 417: return "Expectation Failed"
        case 418: return "I'm a teapot"
        case 420: return "Enhance Your Calm"
        case 422: return "Unprocessable Entity"
        case 423: return "Locked"
        case 424: return "Method Failure"
        case 425: return "Unordered Collection"
        case 426: return "Upgrade Required"
        case 428: return "Precondition Required"
        case 429: return "Too Many Requests"
        case 431: return "Request Header Fields Too Large"
        case 451: return "Unavailable For Legal Reasons"
        case 500: return "Internal Server Error"
        case 501: return "Not Implemented"
        case 502: return "Bad Gateway"
        case 503: return "Service Unavailable"
        case 504: return "Gateway Timeout"
        case 505: return "HTTP Version Not Supported"
        case 506: return "Variant Also Negotiates"
        case 507: return "Insufficient Storage"
        case 508: return "Loop Detected"
        case 509: return "Bandwidth Limit Exceeded"
        case 510: return "Not Extended"
        case 511: return "Network Authentication Required"
        default: return "I'm not a teapot, you are"
        }
    }
}

private class DateLogFormatterHelper {
    static let shared = DateLogFormatterHelper()

    static var fullTimeformatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()

    func fulltimeString(from: Date) -> String {
        return DateLogFormatterHelper.fullTimeformatter.string(from: from)
    }
}
