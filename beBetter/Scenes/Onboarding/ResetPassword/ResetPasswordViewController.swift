import UIKit
import Combine

final class ResetPasswordViewController: BaseViewController, CustomLoadedController {

    let stepSubject = PassthroughSubject<Step, Never>()

    private var bag = Set<AnyCancellable>()

    typealias ViewType = ResetPasswordView

    weak var coordinator: MainCoordinator?

    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "",
                                     image: UIImage(systemName: "xmark.circle"), primaryAction: UIAction(handler: { [unowned self] _ in
            self.stepSubject.send(.resetPasswordCanceled)
        }))
        button.tintColor = UIColor.black

        return button
    }()

    override func loadView() {
        view = ResetPasswordView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = closeButton

        _view.onResetPassword = {
            self.resetPasswordSuccess()
                .subscribe(self.stepSubject)
                .store(in: &self.bag)
        }
    }

    private func resetPasswordSuccess() -> AnyPublisher<Step, Never> {
        Just(.resetPasswordEnded)
            .eraseToAnyPublisher()
    }
}

