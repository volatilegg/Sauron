import Foundation

public class Sauron: ObservableObject {
    public static let shared = Sauron()
    public static let newRequestNotification = Notification.Name("NewRequestUpdate")

    public var dateFormatter: DateFormatter

    public var logMode: NetworkLogMode = .disable {
        didSet {
            resetData()
        }
    }

    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .full
    }

    private var requests: Atomic<[RequestModel.Id: RequestModel]> = .init([:])

    public var requestModels: [RequestModel] {
        return Array(requests.value.values)
    }
    
    @Published var publishedRequests: [RequestViewModel] = []

    public func insertRequest(_ request: RequestModel?) {
        defer {
            updateRequests()
        }

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
        defer {
            updateRequests()
        }

        requests.mutate {
            $0.removeAll()
        }
    }

    private func updateRequests() {
        publishedRequests = Array(requests.value.values.map({ RequestViewModel(requestModel: $0)}))
    }
}

public enum NetworkLogMode {
    case enable
    case disableHeader
    case disable
}
