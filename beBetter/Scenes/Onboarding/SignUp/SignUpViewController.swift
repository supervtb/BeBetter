import UIKit
import Combine

final class SignUpViewController: BaseViewController, CustomLoadedController {

    let stepSubject = PassthroughSubject<Step, Never>()

    private var bag = Set<AnyCancellable>()

    typealias ViewType = SignUpView

    weak var coordinator: MainCoordinator?

    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "",
                                     image: UIImage(systemName: "xmark.circle"), primaryAction: UIAction(handler: { [unowned self] _ in
            self.stepSubject.send(.signUpCanceled)
        }))
        button.tintColor = UIColor.black

        return button
    }()

    override func loadView() {
        view = SignUpView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = closeButton

        _view.onSignUp = {
            self.signUpSuccess()
                .subscribe(self.stepSubject)
                .store(in: &self.bag)
        }
    }

    private func signUpSuccess() -> AnyPublisher<Step, Never> {
        Just(.signUpEnded)
            .eraseToAnyPublisher()
    }
}
