import UIKit
import Combine

final class LoginViewController: BaseViewController, CustomLoadedController {

    let loginSubject = PassthroughSubject<Bool, Never>()

    let signUpSubject = PassthroughSubject<Bool, Never>()

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
                .subscribe(self.loginSubject)
                .store(in: &self.bag)
        }

        _view.onSignUp = {
            self.signUpSubject.send(true)
        }
    }

    private func loginSuccess() -> AnyPublisher<Bool, Never> {
        Just(true)
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
