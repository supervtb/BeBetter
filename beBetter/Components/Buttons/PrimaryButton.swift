import UIKit

/// Primary CTA button, with rounded corners
final class PrimaryButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }

    // MARK: - Constants
    private enum Constants {

        static let cornerRadius: CGFloat = 2
        static let minimumHeight: CGFloat = 48
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor(.aquamarine)
        tintColor = UIColor(.totalyWhite)
        layer.cornerRadius = Constants.cornerRadius
    }

    // MARK: - Updates
    func updateTitle(_ newTitle: String) {
        self.setTitle(newTitle, for: .normal)
    }

    // MARK: - Overrides
    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width,
                      height: max(superSize.height, Constants.minimumHeight))
    }
}

