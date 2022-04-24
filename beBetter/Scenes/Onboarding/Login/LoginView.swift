import UIKit

final class LoginView: AuthorizationBaseView {

    private var contentHeightConstraint: NSLayoutConstraint?

    var onLogin: (() -> Void)?

    private let contentStack: UIStackView = {
        let vStack = UIStackView()
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    private let headerContentStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 12
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    private let fieldsStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 12
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    let emailTextField: FloatingLabelField = {
        let textField = BeBetterTextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        let field = FloatingLabelField(textField: textField)
        field.title = "Please enter your email"
        return field
    }()

    let passwordTextField: FloatingLabelField = {
        let textField = BeBetterSecureTextField()
        textField.placeholder = "Password"
        textField.keyboardType = .emailAddress
        let field = FloatingLabelField(textField: textField)
        field.title = "Please enter your password"
        return field
    }()

    let loginButton: PrimaryButton = {
        let button = PrimaryButton(type: .system)
        button.updateTitle("Login")
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupActions()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func contentView() -> UIView {
        [emailTextField, passwordTextField].forEach {
            fieldsStack.addArrangedSubview($0)
        }

        [headerContentStack, fieldsStack, loginButton, UIView()].forEach {
            contentStack.addArrangedSubview($0)
        }

        return contentStack
    }

    override func updateContent() {
        titleLabel.text = "Login"
    }

    private func setup() {
        backgroundColor = UIColor(.backgroundPrimary)
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(self.onLoginTapped), for: .touchUpInside)
    }

    @objc private func onLoginTapped() {
        onLogin?()
    }
}
