//
//  DefaultPaginationGenerator.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/29.
//

final class DefaultPaginationGenerator<T>: PaginationGenerator {
    
    typealias Elements = Array<T>
    
    typealias Fetch = (
        _ cursor: Int,
        _ size: Int,
        _ completion: @escaping (_ result: Elements) -> Void,
        _ error: @escaping (_ error: Error) -> Void
    ) -> Void
    
    var fetchStatus: FetchStatus = .ready
    
    var cursor: Int
    var size: Int
    
    init(cursor: Int, size: Int) {
        self.cursor = cursor
        self.size = size
    }
    
    func next(fetch: Fetch, onCompletion: ((Elements) -> Void)?, onError: ((Error) -> Void)?) {
        fetchStatus = .loading
        
        fetch(cursor, size, { [weak self] items in
            guard let self else { return }
            self.fetchStatus = .ready
            self.cursor += size
            onCompletion?(items)
        }, { error in
            onError?(error)
        })
    }
}
