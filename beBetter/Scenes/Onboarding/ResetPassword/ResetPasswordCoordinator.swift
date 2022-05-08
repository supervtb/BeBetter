import UIKit
import Combine

final class ResetPasswordCoordinator: BaseCoordinator<Step> {

    lazy var viewController = {
        return ResetPasswordViewController(viewModel: ResetPasswordViewModel())
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
        let dismiss = viewController.stepSubject.filter { $0 == .resetPasswordEnded || $0 == .resetPasswordCanceled }
        return dismiss.eraseToAnyPublisher()
    }
}
