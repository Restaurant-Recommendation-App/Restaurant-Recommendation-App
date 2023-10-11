//
//  NetworkService.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation
import Combine

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkService {
    func request(endpoint: Requestable) -> AnyPublisher<(Data, HTTPURLResponse), NetworkError>
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Implementation

final class DefaultNetworkService: NetworkService {
    
    private let config: NetworkConfigurable
    private let session: URLSession
    private let logger: NetworkErrorLogger
    
    init(config: NetworkConfigurable, session: URLSession = .shared, logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.config = config
        self.session = session
        self.logger = logger
    }
    
    func request(endpoint: Requestable) -> AnyPublisher<(Data, HTTPURLResponse), NetworkError> {
        do {
            let request = try endpoint.urlRequest(with: config)
            return session.dataTaskPublisher(for: request)
                .handleEvents(receiveSubscription: { [weak self] _ in
                    self?.logger.log(request: request)
                }, receiveOutput: { [weak self] data, response in
                    self?.logger.log(responseData: data, response: response)
                }, receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.logger.log(error: error)
                    }
                })
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw NetworkError.urlGeneration
                    }
                    guard 200..<300 ~= httpResponse.statusCode else {
                        throw NetworkError.error(statusCode: httpResponse.statusCode, data: data)
                    }
                    return (data, httpResponse)
                }
                .mapError { error in
                    if let error = error as? NetworkError {
                        return error
                    } else {
                        return NetworkError.generic(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.urlGeneration)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Logger

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: - NetworkError extension

extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
