import UIKit
import Combine

class MainCoordinator: BaseCoordinator<Void> {

    let window: UIWindow

    init(presenting navigationController: NavigationControllerReleaseHandler, in window: UIWindow) {
        self.window = window
        super.init(presenting: navigationController)
    }

    override func start() -> AnyPublisher<Void, Never> {

        // check login state
        if dependencies.userDefaultsManager.isLogged.value == true {
            startTabBar()
        } else {
            startSplash()
        }

        return Publishers.Never()
            .eraseToAnyPublisher()
    }

    private func startSplash() {
        let coordinator = LoginCoordinator(presenting: NavigationController(
            navigationBarClass: TransparentNavigationBar.self,
            toolbarClass: nil)
        )
        setRoot(to: coordinator, into: window)
            .sink { [unowned self] _ in
                self.startTabBar()
            }.store(in: &bag)
    }

    private func startTabBar() {
        let coordinator = TabBarCoordinator(
            presenting: NavigationController(), tabs: Tab.allCases)
        setRoot(to: coordinator, into: window)
            .sink { [unowned self] _ in
                self.startSplash()
            }.store(in: &bag)
    }
}
