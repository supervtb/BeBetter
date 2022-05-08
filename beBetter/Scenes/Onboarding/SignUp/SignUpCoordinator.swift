import UIKit
import Combine

final class SignUpCoordinator: BaseCoordinator<Step> {

    lazy var viewController = {
        return SignUpViewController(viewModel: SignUpViewModel())
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

    override func start() -> AnyPublisher<Step, Never> {
        let dismiss = viewController.stepSubject.filter { $0 == .signUpEnded || $0 == .signUpCanceled }
        return dismiss.eraseToAnyPublisher()
    }
}
