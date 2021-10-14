import Foundation
import UIKit
import Combine

final class AccountCoordinator: BaseCoordinator<Void> {

    private lazy var viewController: AccountViewController = {
        let viewController = AccountViewController(tab: tab)
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

    init(presenting navigationController: NavigationControllerReleaseHandler, tab: Tab) {

        self.tab = tab

        navigationController.tabBarItem = UITabBarItem(title: tab.title,
                                                       image: nil,
                                                       selectedImage: nil)

        super.init(presenting: navigationController)
    }

    override func start() -> AnyPublisher<Void, Never> {

        return viewController.logoutSubject.map { _ in }.eraseToAnyPublisher()

    }
}
