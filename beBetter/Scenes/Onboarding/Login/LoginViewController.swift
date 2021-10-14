import UIKit
import Combine

final class LoginViewController: BaseViewController, CustomLoadedController {

    let completedSubject = PassthroughSubject<Bool, Never>()

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
                .subscribe(self.completedSubject)
                .store(in: &self.bag)
        }
    }

    private func loginSuccess() -> AnyPublisher<Bool, Never> {
        Just(true)
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
