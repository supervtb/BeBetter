import Foundation
import UIKit
import Combine

enum Tab: CaseIterable {
    case home, account

    public var title: String {
        switch self {
        case .home: return "Home"
        case .account: return "Account"
        }
    }
}

final class TabBarCoordinator: BaseCoordinator<Void> {

    let tabs: [Tab]

    let tabbarController: UITabBarController = {
        let controller = UITabBarController()
        controller.tabBar.unselectedItemTintColor = UIColor(.robinSEggBlue)
        controller.tabBar.tintColor = UIColor(.aquamarine)
        return controller
    }()

    override var source: UIViewController {
        get { tabbarController }
        set {}
    }

    init(presenting navigationController: NavigationControllerReleaseHandler, tabs: [Tab]) {
        self.tabs = tabs
        super.init(presenting: navigationController)
    }

    override func start() -> AnyPublisher<Void, Never> {

        let coordinators = tabs.map(configure(tab:))

        let masters = coordinators.map { $0.source }

        let result = coordinators.map { coordinate(to: $0) }

        tabbarController.viewControllers = masters
        tabbarController.selectedIndex = 0

        return Publishers.MergeMany(result)
            .eraseToAnyPublisher()
    }

    private func configure(tab: Tab) -> BaseCoordinator<Void> {
        switch tab {
        case .home:
            return HomeCoordinator(presenting: NavigationController(), tab: tab)
        case .account:
            return AccountCoordinator(presenting: NavigationController(), tab: tab)
        }
    }
}
