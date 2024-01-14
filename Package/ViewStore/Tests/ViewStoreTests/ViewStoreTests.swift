import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(ViewStoreMacros)
import ViewStoreMacros

let testMacros: [String: Macro.Type] = [
    "ViewStore": ViewStoreMacro.self,
]
#endif

final class ViewStoreTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
@ViewStore(SomeReducer.self)
struct SomeView {
}
""",
            expandedSource: """

struct SomeView {

    let store: StoreOf<SomeReducer>

    @ObservedObject var viewStore: ViewStoreOf<SomeReducer>

    init(_ storeOf: StoreOf<SomeReducer>) {
        self.store = storeOf;
        self.viewStore = ViewStore(self.store, observe: {
                $0
            })
    }
}
""",
            macros: testMacros
        )
    }
    
    func testMacroWithPublic() {
        assertMacroExpansion(
            """
@ViewStore(SomeReducer.self)
public struct SomeView {
}
""",
            expandedSource: """

public struct SomeView {

    public let store: StoreOf<SomeReducer>

    @ObservedObject
    public var viewStore: ViewStoreOf<SomeReducer>

    public init(_ storeOf: StoreOf<SomeReducer>) {
        self.store = storeOf;
        self.viewStore = ViewStore(self.store, observe: {
                $0
            })
    }
}
""",
            macros: testMacros
        )
    }
}
