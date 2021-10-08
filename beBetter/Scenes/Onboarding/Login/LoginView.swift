import UIKit

final class LoginView: KeyboardAwareScrollContainerView {

    private var contentHeightConstraint: NSLayoutConstraint?

    var onLogin: (() -> Void)?

    private let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.axis = .vertical
        vStack.spacing = 16
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
        setupViews()
        setupActions()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor.white
    }

    private func setupViews() {
        stackView.layoutMargins = UIEdgeInsets.zero
        scrollView.preservesSuperviewLayoutMargins = true
        let constraints: [Constraint] = [
            equal(\.topAnchor),
            equal(\.bottomAnchor, priority: .defaultHigh),
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor, priority: .defaultHigh)
        ]


        fieldsStack.addArrangedSubview(emailTextField)
        fieldsStack.addArrangedSubview(passwordTextField)


        stackView.addArrangedSubview(fieldsStack)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(UIView())

        scrollView.addSubview(stackView, constraints: constraints)
        contentHeightConstraint = stackView.heightAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.heightAnchor)
        contentHeightConstraint?.isActive = true

    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(self.onLoginTapped), for: .touchUpInside)
    }

    @objc private func onLoginTapped() {
        onLogin?()
    }
}
