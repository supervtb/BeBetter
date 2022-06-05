public typealias DependencyContainer = AccountManagerProvider

public protocol AccountManagerProvider {

    var accountManager: AccountManagerType { get }
}
