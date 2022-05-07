import UIKit
import Combine

final class SignUpCoordinator: BaseCoordinator<Bool> {

    lazy var viewController = {
        return SignUpViewController()
    }()

    override var source: UIViewController {
        get {
            router.navigationController.viewControllers = [viewController]
            return router.navigationController
        }
        set {}
    }

    init(presenting navigationController: NavigationController) {
        super.init(presenting: navigationController)
        self.source = viewController
    }

    override func start() -> AnyPublisher<Bool, Never> {
        let dismiss = viewController.completedSubject.filter { $0 == true }

        let multiplePresentResult = viewController.presentSubject
            .eraseToAnyPublisher()
            .flatMap { _ -> AnyPublisher<Bool, Never> in
                let coordinator = SignUpCoordinator(presenting: NavigationController())
                return self.present(to: coordinator)
            }.filter { $0 == true }

        return Publishers.Merge(dismiss, multiplePresentResult)
            .eraseToAnyPublisher()
    }
}
