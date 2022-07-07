import UIKit
import Combine

final class LoginViewController: BaseViewController, CustomLoadedController {

    let stepSubject = PassthroughSubject<Step, Never>()

    private var bag = Set<AnyCancellable>()
    
    typealias ViewType = LoginView

    weak var coordinator: MainCoordinator?

    lazy var forgotPasswordButton: UIBarButtonItem = {
        let title = "Forgot password?"
        let button = UIBarButtonItem(title: title,
                                     image: nil, primaryAction: UIAction(handler: { [unowned self] _ in
            self.stepSubject.send(.resetPassword)
        }))
        button.setTitleTextAttributes([.font: UIFont.customFont(name: .gilroyBold, size: 16),
                                                     .foregroundColor: UIColor(.blackColor)],
                                                    for: .normal)
        return button
    }()

    lazy var isLoginButtonEnabled: AnyPublisher<Bool, Never>? = {
        guard let viewModel = self.viewModel as? LoginViewModel else {
            return nil
        }

        return Publishers.CombineLatest(viewModel.isNetworkLoading, viewModel.isLoginValidPublisher)
            .map { requestProcessing, isLoginFormValid in
                return !requestProcessing && isLoginFormValid
            }
            .eraseToAnyPublisher()
    }()

    override func loadView() {
        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForgotPasswordButton()

        guard let viewModel = viewModel as? LoginViewModel else {
            fatalError()
        }
        	
        // Disable login button
        _view.loginButton.isEnabled = false

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

        // Subscribe to validation property and update login button state
        isLoginButtonEnabled?
            .assign(to: \.isEnabled, on: self._view.loginButton)
            .store(in: &bag)

        // Handle login button action
        _view.onLogin = {
            viewModel.doLogin()
        }

        // Handle login success
        viewModel.isSuccess.sink { _ in
            self.stepSubject.send(.loggedIn)
        }.store(in: &bag)

        // Handle login error
        viewModel.isError.sink { errorMessage in
            self.stepSubject.send(.alert(BeBetterAlertConfiguration.loginError(errorMessage)))
        }.store(in: &bag)

        // Handle signup button action
        _view.onSignUp = {
            self.stepSubject.send(.signUp)
        }
    }

    private func setupForgotPasswordButton() {
        navigationItem.rightBarButtonItem = forgotPasswordButton
    }
}
