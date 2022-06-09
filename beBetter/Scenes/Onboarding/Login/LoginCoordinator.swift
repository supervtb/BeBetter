import UIKit
import Combine

final class LoginCoordinator: BaseCoordinator<Void> {

    lazy var viewController = { () -> LoginViewController in
        let model = LoginViewModel(
            accountProvider: dependencies.accountManager,
            userDefaultsProvider: dependencies.userDefaultsManager
        )
        return LoginViewController(viewModel: model)
    }()

    override var source: UIViewController {
        get {
            router.navigationController.viewControllers = [viewController]
            return router.navigationController
        }
        set {}
    }

    override func start() -> AnyPublisher<Void, Never> {

        viewController.stepSubject
            .filter { $0 == .signUp }
            .flatMap { _ in self.startSignUp() }
            .sink { step in
                if step == .signUpEnded {
                    self.viewController.stepSubject.send(.loggedIn)
                }
            }
            .store(in: &bag)

        viewController.stepSubject
            .filter { $0 == .resetPassword }
            .flatMap { _ in self.startResetPassword() }
            .sink(receiveValue: { _ in })
            .store(in: &bag)


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


        return viewController.stepSubject.filter { $0 == .loggedIn }
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    private func startSignUp() -> AnyPublisher<Step, Never> {
        let coordinator = SignUpCoordinator(presenting: NavigationController())
        return present(to: coordinator)
    }

    private func startResetPassword() -> AnyPublisher<Step, Never> {
        let coordinator = ResetPasswordCoordinator(presenting: NavigationController())
        return present(to: coordinator)
    }

    private func showError(config: AlertConfiguration<DefaultAlertAction>) {
        let controller = AlertViewController(configuration: config)
        viewController.present(controller, animated: true)

    }
}
