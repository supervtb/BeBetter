import UIKit
import Combine

final class LoginViewController: BaseViewController, CustomLoadedController {

    let stepSubject = PassthroughSubject<Step, Never>()

    private var bag = Set<AnyCancellable>()
    
    typealias ViewType = LoginView

    weak var coordinator: MainCoordinator?

    override func loadView() {
        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        _view.onLogin = {
            self.loginSuccess()
                .subscribe(self.stepSubject)
                .store(in: &self.bag)
        }

        _view.onSignUp = {
            self.stepSubject.send(.signUp)
        }
    }

    private func loginSuccess() -> AnyPublisher<Step, Never> {
        Just(.loggedIn)
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
