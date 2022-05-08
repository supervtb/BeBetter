import UIKit

open class AuthorizationBaseView: KeyboardAwareScrollContainerView {

    static func subtitleString(from originalString: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        // converting sketch lineHeight to lineSpacing
        // from https://stackoverflow.com/a/53529751/6614480
        let font = UIFont.customFont(name: .gilroyRegular, size: 16)
        style.lineSpacing = 23 - 16 - (font.lineHeight - font.pointSize)
        let attr = [NSAttributedString.Key.font: font as Any,
                    .foregroundColor: UIColor(.blackColor),
                    .paragraphStyle: style]
        let attrString = NSAttributedString(string: originalString,
                                            attributes: attr)
        return attrString
    }

    let iconView: UIImageView = {
        let imageView = UIImageView()
        // Multiplier is image size dependent
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor,
                                         multiplier: 48 / 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(.blackColor)
        label.font = UIFont.customFont(name: .gilroyBold, size: 28)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(.blackColor)
        label.font = UIFont.customFont(name: .gilroyRegular, size: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var contentHeightConstraint: NSLayoutConstraint?

    private let topStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 0
        vStack.distribution = .fill
        vStack.alignment = .fill
        vStack.isLayoutMarginsRelativeArrangement = true
        return vStack
    }()

    private let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
        updateContent()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor(.whiteColor)
    }

    private func setupSubviews() {

        stackView.layoutMargins = UIEdgeInsets(top: 32,
                                               left: 0,
                                               bottom: 16,
                                               right: 0)
        let leftAlignedStack = leftAlignedStackView()
        leftAlignedStack.addArrangedSubview(iconView)
        [leftAlignedStack, titleLabel, subtitleLabel].forEach {
            topStack.addArrangedSubview($0)
        }
        topStack.setCustomSpacing(24, after: leftAlignedStack)
        topStack.setCustomSpacing(8, after: titleLabel)
        stackView.addArrangedSubview(topStack)
        stackView.addArrangedSubview(contentView())
        stackView.setCustomSpacing(40, after: topStack)
        scrollView.preservesSuperviewLayoutMargins = true
        let constraints: [Constraint] = [
            equal(\.topAnchor),
            equal(\.bottomAnchor, priority: .defaultHigh),
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor, priority: .defaultHigh)
        ]
        scrollView.addSubview(stackView, constraints: constraints)
        contentHeightConstraint = stackView.heightAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.heightAnchor)
        contentHeightConstraint?.isActive = true
    }

    func updateContent() {}

    func contentView() -> UIView {
        fatalError("Must be overriden in subclasses")
    }

    override func animateChanges(keyboardHeight: CGFloat) {
        super.animateChanges(keyboardHeight: keyboardHeight)
        contentHeightConstraint?.constant = -keyboardHeight
    }

    // MARK: - Helpers

    func leftAlignedStackView() -> UIStackView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 0
        vStack.distribution = .fill
        vStack.alignment = .leading
        return vStack
    }
}
