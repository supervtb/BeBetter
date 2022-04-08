import UIKit
import Combine

final class LoginCoordinator: BaseCoordinator<Void> {

    lazy var viewController = {
        return LoginViewController()
    }()

    override var source: UIViewController  {
        get { viewController }
        set {}
    }

    override func start() -> AnyPublisher<Void, Never> {
        return viewController.completedSubject
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
