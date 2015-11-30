import Foundation

/// Network activity change notification type.
public enum NetworkActivityChangeType {
    case Began, Ended, Processing(Int64, Int64, Int64)
}

/// Provides each request with optional NSURLCredentials.
public final class NetworkActivityPlugin: Plugin {
    
    public typealias NetworkActivityClosure = (change: NetworkActivityChangeType) -> ()
    let networkActivityClosure: NetworkActivityClosure
    
    public init(networkActivityClosure: NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }

    // MARK: Plugin

    /// Called by the provider as soon as the request is about to start
    public func willSendRequest(request: MoyaRequest, target: MoyaTarget) {
        networkActivityClosure(change: .Began)
    }
    
    /// Called by the provider as soon as a response arrives
    public func didReceiveResponse(result: Result<Moya.Response, Moya.Error>, target: MoyaTarget) {
        networkActivityClosure(change: .Ended)
    }

    /// Called by the provider periodically during the lifecycle of the request as data is written to or read from the server
    public func processingRequest(request: MoyaRequest, target: MoyaTarget, progress: (Int64, Int64, Int64)) {
        networkActivityClosure(change: .Processing(progress))
    }
}

