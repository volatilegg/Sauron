import Foundation

public class Sauron {
    public static let shared = Sauron()
    public static let newRequestNotification = Notification.Name("WhimNewRequestUpdate")

    var logMode: NetworkLogMode = .disable {
        didSet {
            resetData()
        }
    }

    private let requests: Atomic<[RequestModel.Id: RequestModel]> = .init([:])

    public var requestModels: [RequestModel] {
        return Array(requests.value.values)
    }

    public func insertRequest(_ request: RequestModel?) {
        // Safety first 👷‍♀️
        if logMode == .disable {
            resetData()
            return
        }

        guard let request = request else {
            return
        }

        if logMode == .disableHeader {
            request.removeHeaders()
        }

        requests.mutate {
            $0[request.id] = request
        }
        NotificationCenter.default.post(name: Sauron.newRequestNotification, object: nil)
    }

    public func resetData() {
        requests.mutate {
            $0.removeAll()
        }
    }
}

public enum NetworkLogMode {
    case enable
    case disableHeader
    case disable
}
