import UIKit

final class LoginView: AuthorizationBaseView {

    private var contentHeightConstraint: NSLayoutConstraint?

    var onLogin: (() -> Void)?

    var onSignUp: (() -> Void)?

    let emailTextField: FloatingLabelField = {
        let textField = BeBetterTextField()
        textField.placeholder = "Please enter your email"
        textField.keyboardType = .emailAddress
        let field = FloatingLabelField(textField: textField)
        field.title = "Email"
        return field
    }()

    let passwordTextField: FloatingLabelField = {
        let textField = BeBetterTextField()
        textField.placeholder = "Please enter your password"
        textField.keyboardType = .default
        let field = FloatingLabelField(textField: textField)
        field.title = "Password"
        return field
    }()

    let loginButton: PrimaryButton = {
        let button = PrimaryButton(type: .system)
        button.updateTitle("Login")
        return button
    }()

    let signUpButton: PrimaryButton = {
        let button = PrimaryButton(type: .system)
        button.updateTitle("Sign Up")
        return button
    }()

    private let fieldsStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 12
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    private let contentStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.distribution = .equalCentering
        vStack.alignment = .fill
        return vStack
    }()

    private let buttonsContentStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.distribution = .fillEqually
        hStack.alignment = .fill
        return hStack
    }()

    override func updateContent() {
        titleLabel.text = "Welcome to beBetter"
        subtitleLabel.isHidden = true
        subtitleLabel.text = nil

        setupActions()
    }

    override func contentView() -> UIView {
        [emailTextField, passwordTextField].forEach {
            fieldsStack.addArrangedSubview($0)
        }

        [loginButton, signUpButton].forEach {
            buttonsContentStack.addArrangedSubview($0)
        }
        [fieldsStack, buttonsContentStack].forEach {
            contentStack.addArrangedSubview($0)
        }
        return contentStack
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(self.onLoginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(self.onSignUpTapped), for: .touchUpInside)
    }

    @objc private func onLoginTapped() {
        onLogin?()
    }

    @objc private func onSignUpTapped() {
        onSignUp?()
    }
}
