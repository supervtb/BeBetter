import UIKit
import Combine

final class LoginCoordinator: BaseCoordinator<Void> {

    lazy var viewController = {
        return LoginViewController()
    }()

    override var source: UIViewController {
        get {
            router.navigationController.viewControllers = [viewController]
            return router.navigationController
        }
        set {}
    }

    override func start() -> AnyPublisher<Void, Never> {
        viewController.signUpSubject
            .flatMap { [unowned self] _ in
                self.startSignUp()
            }.sink(receiveValue: { _ in
                //
            })
            .store(in: &bag)

        return viewController.loginSubject
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    private func startSignUp() -> AnyPublisher<Bool, Never> {
        let coordinator = SignUpCoordinator(presenting: NavigationController())
        return present(to: coordinator)
    }
}
