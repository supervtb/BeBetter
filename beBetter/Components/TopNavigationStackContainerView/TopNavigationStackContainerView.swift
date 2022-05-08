import UIKit

class TopNavigationStackContainerView: KeyboardAwareScrollContainerView, NavigationTopViewContainer {

    let navigationTopView = NavigationTopView()

    let actionButton = PrimaryButton(type: .system)

    private let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    private var contentHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        backgroundColor = UIColor(.backgroundPrimary)
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
            equal(\.bottomAnchor, \.layoutMarginsGuide.bottomAnchor,
                  priority: .defaultHigh),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor, priority: .defaultHigh)
        ])

        scrollView.topAnchor.constraint(equalTo: navigationTopView.bottomAnchor).isActive = true
        updateContent(stackView: stackView)
        let contentHeightAnchor = navigationTopView.bottomAnchor.anchorWithOffset(to: layoutMarginsGuide.bottomAnchor)
        contentHeightConstraint = stackView.heightAnchor.constraint(lessThanOrEqualTo: contentHeightAnchor)
        //contentHeightConstraint?.priority = .defaultHigh
        contentHeightConstraint?.isActive = true
    }

    override func addScrollView() {
        addSubview(scrollView, constraints: [
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.widthAnchor),
            equal(\.bottomAnchor)
        ])
    }

    func updateContent(stackView: UIStackView) {}

    override func animateChanges(keyboardHeight: CGFloat) {
        super.animateChanges(keyboardHeight: keyboardHeight)
        contentHeightConstraint?.constant = -keyboardHeight
        navigationTopView.layoutIfNeeded()
    }
}
