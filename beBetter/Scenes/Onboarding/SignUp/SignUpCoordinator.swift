import UIKit
import Combine

final class SignUpCoordinator: BaseCoordinator<Step> {

    lazy var viewController = { () -> SignUpViewController in
        let model = SignUpViewModel(accountProvider: dependencies.accountManager)
        return SignUpViewController(viewModel: model)
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
