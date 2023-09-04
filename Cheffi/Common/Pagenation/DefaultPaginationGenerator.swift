//
//  DefaultPaginationGenerator.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/29.
//

final class DefaultPaginationGenerator<T>: PaginationGenerator {
    
    typealias Elements = Array<T>
    
    typealias Fetch = (
        _ page: Int,
        _ completion: @escaping (_ result: Elements) -> Void,
        _ error: @escaping (_ error: Error) -> Void
    ) -> Void
    
    var fetchStatus: FetchStatus = .ready
    
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    func next(fetch: Fetch, onCompletion: ((Elements) -> Void)?, onError: ((Error) -> Void)?) {
        fetchStatus = .loading
        
        fetch(page, { [weak self] items in
            guard let self else { return }
            self.fetchStatus = .ready
            self.page += 1
            onCompletion?(items)
        }, { error in
            onError?(error)
        })
    }
}
