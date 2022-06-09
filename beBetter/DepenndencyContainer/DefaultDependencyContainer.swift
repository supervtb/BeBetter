final class DefaultDependencyContainer: DependencyContainer {

    let accountManager = AccountManager() as AccountManagerType

    let userDefaultsManager = UserDefaultsManagerImpl() as UserDefaultsManager
}
