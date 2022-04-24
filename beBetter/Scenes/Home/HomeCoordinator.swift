import UIKit
import Combine

final class HomeCoordinator: BaseCoordinator<Void> {

    private lazy var viewController: HomeViewController = {
        let viewController = HomeViewController(tab: tab)
        return viewController
    }()

    override var source: UIViewController {
        get {
            router.navigationController.viewControllers = [viewController]
            return router.navigationController
        }
    }

    private let tab: Tab

    private let itemIconName = "house"

    private let selectedItemIconName = "house.fill"

    init(presenting navigationController: NavigationControllerReleaseHandler, tab: Tab) {

        self.tab = tab

        navigationController.tabBarItem = UITabBarItem(title: tab.title,
                                                       image: UIImage(systemName: itemIconName),
                                                       selectedImage: UIImage(systemName: selectedItemIconName))

        super.init(presenting: navigationController)
    }

    override func start() -> AnyPublisher<Void, Never> {
        return Publishers.Never()
            .eraseToAnyPublisher()
    }
}
