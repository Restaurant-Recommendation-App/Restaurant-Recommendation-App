/// A macro that produces 2 stored properties and initializer.
/// Requires the Reducer's type as an argument, in the form `ReducerType.self`.
///
/// ```swift
/// @ViewStore(SomeReducer.self)
/// struct SomeView: View {
///     var body: some View {
///         Text(viewStore.text)
///     }
/// }
/// ```
@attached(member, names: named(store), named(viewStore), named(init(_:)))
public macro ViewStore<T>(_: T.Type) = #externalMacro(module: "ViewStoreMacros", type: "ViewStoreMacro")
