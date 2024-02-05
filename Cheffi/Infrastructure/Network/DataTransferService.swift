//
//  DataTransfer.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation
import Combine

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        on queue: DispatchQueue
    ) -> AnyPublisher<(T, HTTPURLResponse), DataTransferError> where E.Response == T
    
    func request<E: ResponseRequestable>(
        with endpoint: E,
        on queue: DispatchQueue
    ) -> AnyPublisher<Void, DataTransferError> where E.Response == Void
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

protocol DataTransferErrorLogger {
    func log(error: Error)
}

final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorLogger: DataTransferErrorLogger
    
    init(
        with networkService: NetworkService,
        errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorLogger = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        on queue: DispatchQueue
    ) -> AnyPublisher<(T, HTTPURLResponse), DataTransferError> where E.Response == T {
        return networkService.request(endpoint: endpoint)
            .mapError { networkError -> DataTransferError in
                self.errorLogger.log(error: networkError)
                return DataTransferError.networkFailure(networkError)
            }
            .tryMap { data, response in
                let decodedData: T = try endpoint.responseDecoder.decode(data)
                return (decodedData, response)
            }
            .mapError { error in
                if let error = error as? DataTransferError {
                    return error
                } else {
                    self.errorLogger.log(error: error)
                    return DataTransferError.parsing(error)
                }
            }
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
    
    func request<E: ResponseRequestable>(
        with endpoint: E,
        on queue: DispatchQueue
    ) -> AnyPublisher<Void, DataTransferError> where E.Response == Void {
        return networkService.request(endpoint: endpoint)
            .mapError { networkError -> DataTransferError in
                self.errorLogger.log(error: networkError)
                return DataTransferError.networkFailure(networkError)
            }
            .map { _ in () }
            .receive(on: queue)
            .eraseToAnyPublisher()
    }

    // MARK: - Private
    private func decode<T: Decodable>(
        data: Data?,
        decoder: ResponseDecoder
    ) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
}

// MARK: - Logger
final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
    
    func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - Response Decoders
class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }
}
