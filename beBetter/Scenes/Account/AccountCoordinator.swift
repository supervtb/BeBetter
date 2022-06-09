import Foundation
import UIKit
import Combine

final class AccountCoordinator: BaseCoordinator<Void> {

    private lazy var viewController: AccountViewController = {
        let model = AccountViewModel(
            accountProvider: dependencies.accountManager,
            userDefaultsProvider: dependencies.userDefaultsManager
        )
        let viewController = AccountViewController(tab: tab, viewModel: model)
        return viewController
    }()

    override var source: UIViewController  {
        get {
            router.navigationController.viewControllers = [viewController]
            return router.navigationController
        }
        set {}
    }

    private let tab: Tab

    private let itemIconName = "person"

    private let selectedItemIconName = "person.fill"

    init(presenting navigationController: NavigationControllerReleaseHandler, tab: Tab) {

        self.tab = tab

        navigationController.tabBarItem = UITabBarItem(title: tab.title,
                                                       image: UIImage(systemName: itemIconName),
                                                       selectedImage: UIImage(systemName: selectedItemIconName))

        super.init(presenting: navigationController)
    }

    override func start() -> AnyPublisher<Void, Never> {

        return viewController.logoutSubject.map { _ in }.eraseToAnyPublisher()

    }
}
