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
        _view.emailTextField
            .textField
            .textPublisher
            .assign(to: \.value, on: viewModel.email)
            .store(in: &bag)

        // Bind password string to model
        _view.passwordTextField
            .textField
            .textPublisher
            .assign(to: \.value, on: viewModel.password)
            .store(in: &bag)

        // Bind confirm password string to model
        _view.confirmPasswordTextField
            .textField
            .textPublisher
            .assign(to: \.value, on: viewModel.confirmPassword)
            .store(in: &bag)

        // Subscribe to validation property and update signup button state
        viewModel.isSignUpValidPublisher
            .assign(to: \.isEnabled, on: _view.signUpButton)
            .store(in: &bag)

        // Handle sign up action
        _view.onSignUp = {
            viewModel.doSignUp()
        }

        // Handle sign up success
        viewModel.isSuccess.sink { _ in
            self.stepSubject.send(.signUpEnded)
        }.store(in: &bag)

        // Handle sign up error
        viewModel.isError.sink { error in
            self.stepSubject.send(.alert(BeBetterAlertConfiguration.loginError(error)))
        }.store(in: &bag)
    }
}
