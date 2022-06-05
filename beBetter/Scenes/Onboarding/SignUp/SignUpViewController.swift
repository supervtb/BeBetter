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

        guard let viewModel = viewModel as? SignUpViewModel else {
            fatalError()
        }

        // Disable signup button
        _view.signUpButton.isEnabled = false

        // Bind email string to model
        _view.emailTextField.textField.textPublisher.sink { val in
            viewModel.email.send(val)
        }.store(in: &bag)

        // Bind password string to model
        _view.passwordTextField.textField.textPublisher.sink { val in
            viewModel.password.send(val)
        }.store(in: &bag)

        // Bind confirm password string to model
        _view.confirmPasswordTextField.textField.textPublisher.sink { val in
            viewModel.confirmPassword.send(val)
        }.store(in: &bag)

        // Subscribe to validation property and update signup button state
        viewModel.isSignUpValidPublisher.sink { val in
            self._view.signUpButton.isEnabled = val
        }.store(in: &bag)

        // Handle sign up action
        _view.onSignUp = {
            viewModel.doSignUp()
        }

        // Handle sign up success
        viewModel.isSuccess.sink { _ in
            self.stepSubject.send(.signUpEnded)
        }.store(in: &bag)

        // Handle sign up error
        viewModel.isError.sink { _ in
            print("User can not sign up")
        }.store(in: &bag)
    }
}
