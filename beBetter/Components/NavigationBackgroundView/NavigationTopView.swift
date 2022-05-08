import UIKit

public class NavigationTopView: UIView {

    // MARK: - Constants

    // swiftlint:disable large_tuple
    private enum Constants {
        static let shadow: (x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) = (0, 0, 14, 0)
    }

    // MARK: - Components

    static func titleLabel() -> UILabel {
        let label = UILabel()
        return label
    }

    static func subtitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(.pinkishGrey)
        //label.font = FontFamily.Gilroy.medium.font(size: 14)
        return label
    }

    static func backgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(.totalyWhite)
        view.layer.applySketchShadow(color: UIColor(.navigationShadow),
                                     alpha: 1,
                                     x: Constants.shadow.x,
                                     y: Constants.shadow.y,
                                     blur: Constants.shadow.blur,
                                     spread: Constants.shadow.spread)
        return view
    }

    static func titleString(from originalString: String) -> NSAttributedString {
        let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24),//FontFamily.Gilroy.bold.font(size: 24) as Any,
                    .foregroundColor: UIColor(.blackColor),
                    .kern: CGFloat(-0.55)] as [NSAttributedString.Key : Any]
        let attrString = NSAttributedString(string: originalString,
                                            attributes: attr)
        return attrString
    }

    // MARK: - Public properties

    public var title: String? = "" {
        didSet {
            updateTitle(title)
        }
    }

    public var subtitle: String? = "" {
        didSet {
            updateSubtitle(subtitle)
        }
    }

    // MARK: - Private properties

    public let titleLabel = NavigationTopView.titleLabel()

    public let subtitleLabel = NavigationTopView.subtitleLabel()

    private let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 6
        vStack.isLayoutMarginsRelativeArrangement = true
        return vStack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        requiredInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        requiredInit()
    }

    private func requiredInit() {
        preservesSuperviewLayoutMargins = true
        backgroundColor = UIColor(.totalyWhite)
        layer.applySketchShadow(color: UIColor(.navigationShadow),
                                alpha: 1,
                                x: Constants.shadow.x,
                                y: Constants.shadow.y,
                                blur: Constants.shadow.blur,
                                spread: Constants.shadow.spread)
        [titleLabel, subtitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView, constraints: [
            equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor),
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor, priority: .defaultHigh),
            equal(\.bottomAnchor, priority: .defaultHigh)
        ])
    }

    private func updateTitle(_ newValue: String?) {
        guard let newValue = newValue else {
            titleLabel.isHidden = true
            titleLabel.text = nil
            return
        }
        titleLabel.isHidden = false
        titleLabel.attributedText = NavigationTopView.titleString(from: newValue)
        updateLayoutMargins()
    }

    private func updateSubtitle(_ newValue: String?) {
        guard let newValue = newValue else {
            titleLabel.isHidden = true
            titleLabel.text = nil
            return
        }
        subtitleLabel.isHidden = false
        subtitleLabel.text = newValue
        updateLayoutMargins()
    }

    private func updateLayoutMargins() {
        let margin: CGFloat = !titleLabel.isHidden || !subtitleLabel.isHidden ? 32 : 0
        guard stackView.layoutMargins.top != margin else {
            return
        }
        stackView.layoutMargins = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        setNeedsLayout()
    }
}
