import UIKit

open class AuthorizationBaseView: KeyboardAwareScrollContainerView {

    private var contentHeightConstraint: NSLayoutConstraint?

    private let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    private let topStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 0
        vStack.distribution = .fill
        vStack.alignment = .fill
        vStack.isLayoutMarginsRelativeArrangement = true
        return vStack
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Login"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor.white
    }

    private func setupViews() {

        topStack.addArrangedSubview(titleLabel)

        stackView.layoutMargins = UIEdgeInsets.zero
        scrollView.preservesSuperviewLayoutMargins = true
        let constraints: [Constraint] = [
            equal(\.topAnchor),
            equal(\.bottomAnchor, priority: .defaultHigh),
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor, priority: .defaultHigh)
        ]

        stackView.addArrangedSubview(topStack)
        stackView.addArrangedSubview(contentView())

        scrollView.addSubview(stackView, constraints: constraints)
        contentHeightConstraint = stackView.heightAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.heightAnchor)
        contentHeightConstraint?.isActive = true

    }

    func contentView() -> UIView {
        fatalError("Must be overriden in subclasses")
    }
}

