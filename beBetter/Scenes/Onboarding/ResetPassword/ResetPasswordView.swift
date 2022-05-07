import UIKit

final class ResetPasswordView: AuthorizationBaseView {

    private var contentHeightConstraint: NSLayoutConstraint?

    var onResetPassword: (() -> Void)?

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

    let resetPasswordButton: PrimaryButton = {
        let button = PrimaryButton(type: .system)
        button.updateTitle("Reset")
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

        fieldsStack.addArrangedSubview(emailTextField)


        [headerContentStack, fieldsStack, resetPasswordButton, UIView()].forEach {
            contentStack.addArrangedSubview($0)
        }

        return contentStack
    }

    override func updateContent() {
        titleLabel.text = "Reset password"
    }

    private func setup() {
        backgroundColor = UIColor(.backgroundPrimary)
    }

    private func setupActions() {
        resetPasswordButton.addTarget(self, action: #selector(self.onResetPasswordTapped), for: .touchUpInside)
    }

    @objc private func onResetPasswordTapped() {
        onResetPassword?()
    }
}

