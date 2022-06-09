import UIKit
import Combine

final class SignUpCoordinator: BaseCoordinator<Step> {

    lazy var viewController = { () -> SignUpViewController in
        let model = SignUpViewModel(
            accountProvider: dependencies.accountManager,
            userDefaultsProvider: dependencies.userDefaultsManager
        )
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
        viewController.stepSubject
            .filter { $0 == .alert(BeBetterAlertConfiguration.loginError()) }
            .sink(receiveValue: { val in
                switch val {
                case .alert(let alert):
                    self.showError(config: alert)
                default: return
                }
            })
            .store(in: &bag)
        let dismiss = viewController.stepSubject.filter { $0 == .signUpEnded || $0 == .signUpCanceled }
        return dismiss.eraseToAnyPublisher()
    }

    private func showError(config: AlertConfiguration<DefaultAlertAction>) {
        let controller = AlertViewController(configuration: config)
        viewController.present(controller, animated: true)
    }
}
