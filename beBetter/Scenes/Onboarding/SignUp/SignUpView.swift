import UIKit

final class SignUpView: AuthorizationBaseView {

    private var contentHeightConstraint: NSLayoutConstraint?

    var onSignUp: (() -> Void)?

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
        textField.placeholder = "Please enter your email"
        textField.keyboardType = .emailAddress
        let field = FloatingLabelField(textField: textField)
        field.title = "Email"
        return field
    }()

    let passwordTextField: FloatingLabelField = {
        let textField = BeBetterSecureTextField()
        textField.placeholder = "Please enter your password"
        textField.keyboardType = .default
        let field = FloatingLabelField(textField: textField)
        field.title = "Password"
        return field
    }()

    let confirmPasswordTextField: FloatingLabelField = {
        let textField = BeBetterSecureTextField()
        textField.placeholder = "Please enter your password again"
        textField.keyboardType = .default
        let field = FloatingLabelField(textField: textField)
        field.title = "Confirm password"
        return field
    }()

    let signUpButton: PrimaryButton = {
        let button = PrimaryButton(type: .system)
        button.updateTitle("Register")
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
        [emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            fieldsStack.addArrangedSubview($0)
        }

        [headerContentStack, fieldsStack, signUpButton, UIView()].forEach {
            contentStack.addArrangedSubview($0)
        }

        return contentStack
    }

    override func updateContent() {
        titleLabel.text = "Register"
    }

    private func setup() {
        backgroundColor = UIColor(.backgroundPrimary)
    }

    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(self.onSignUpTapped), for: .touchUpInside)
    }

    @objc private func onSignUpTapped() {
        onSignUp?()
    }
}
