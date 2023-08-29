//
//  PagenationGenerator.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/29.
//

/// 페이지네이션 패치 상태
enum FetchStatus {
    /// 준비
    case ready
    /// 데이터 패칭중
    case loading
}

protocol PagenationGenerator {
    /// 페이지네이션을 통해 패칭할 데이터 타입
    associatedtype Elements
    /// 페이지네이션 로직을 실행할 클로저 타입
    associatedtype Fetch
    
    /// 현재 페이지네이션 상태
    var fetchStatus: FetchStatus { get set }
    
    /// 페이지네이션 기능을 수행합니다
    /// - Parameters:
    ///   - fetch: 데이터 패칭을 실행하는 클로저
    ///   - onCompletion: 데이터 패칭 성공 이후 실행할 클로저
    ///   - onError: 데이터 패칭 에러 발생시 실행할 클로저
    mutating func next(fetch: Fetch, onCompletion: ((Elements) -> Void)?, onError: ((Error) -> Void)?)
}
