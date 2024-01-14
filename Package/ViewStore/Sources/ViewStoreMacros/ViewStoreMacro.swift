import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct ViewStoreMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax, 
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            case .argumentList(let arguments) = node.arguments,
            arguments.count == 1,
            let memberAccessExn = arguments.first?
                .expression.as(MemberAccessExprSyntax.self),
            let storeType = memberAccessExn.base?.as(DeclReferenceExprSyntax.self)
        else {
            throw CustomError.message(#"@ViewStore requires the store's type as an argument, in the form "Type.self"."#)
        }
        
        guard declaration.is(StructDeclSyntax.self) else {
            throw CustomError.message("@ViewStore can only be applied to a struct declarations.")
        }
        
        let access = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)
        
        return [
            "\(access)let store: StoreOf<\(storeType)>",
            "@ObservedObject \(access)var viewStore: ViewStoreOf<\(storeType)>",
            "\(access)init(_ storeOf: StoreOf<\(storeType)>) { self.store = storeOf; self.viewStore = ViewStore(self.store, observe: { $0 }) }"
        ]
    }
}

@main
struct ViewStorePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ViewStoreMacro.self,
    ]
}

enum CustomError: Error, CustomStringConvertible {
    case message(String)
    
    var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}

extension DeclModifierSyntax {
    var isNeededAccessLevelModifier: Bool {
        switch self.name.tokenKind {
        case .keyword(.public): return true
        default: return false
        }
    }
}

extension SyntaxStringInterpolation {
    // It would be nice for SwiftSyntaxBuilder to provide this out-of-the-box.
    mutating func appendInterpolation<Node: SyntaxProtocol>(_ node: Node?) {
        if let node {
            appendInterpolation(node)
        }
    }
}
