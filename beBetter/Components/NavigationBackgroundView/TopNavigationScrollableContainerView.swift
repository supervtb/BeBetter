import UIKit

class TopNavigationScrollableContainerView: KeyboardAwareScrollContainerView, NavigationTopViewContainer {

    let navigationTopView = NavigationTopView()

    let actionButton = PrimaryButton(type: .system)

    private let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 70, right: 0)
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    private var actionButtonBottomConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        backgroundColor = UIColor(.whiteColor)
    }

    private func setupSubviews() {
        addSubview(navigationTopView, constraints: [
            equal(\.topAnchor),
            equal(\.leadingAnchor),
            equal(\.trailingAnchor)
        ])
        navigationTopView.setContentCompressionResistancePriority(.required, for: .vertical)

        scrollView.addSubview(stackView, constraints: [
            equal(\.topAnchor),
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor),
            greaterThanOrEqualTo(\.bottomAnchor)
        ])

        scrollView.topAnchor.constraint(equalTo: navigationTopView.bottomAnchor).isActive = true

        scrollView.addSubview(actionButton, constraints: [
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor)
        ])

        actionButtonBottomConstraint = actionButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -25)
        actionButtonBottomConstraint?.isActive = true

        updateContent(stackView: stackView)
    }

    override func addScrollView() {
        addSubview(scrollView, constraints: [
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.bottomAnchor)
        ])
    }

    func updateContent(stackView: UIStackView) {}

    override func animateChanges(keyboardHeight: CGFloat) {
        super.animateChanges(keyboardHeight: keyboardHeight)

        actionButtonBottomConstraint?.constant = -(keyboardHeight + 25)
        navigationTopView.layoutIfNeeded()
    }
}

