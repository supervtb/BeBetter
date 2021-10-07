import UIKit

class FloatingLabelField: UIView {

    // MARK: - Public properties

    let textField: UITextField

    var title: String? {
        didSet {
            updateTitle()
        }
    }

    var errorMessage: String? {
        didSet {
            updateTitle()
            updateTitleVisibility()
        }
    }

    var hasErrorMessage: Bool {
        return errorMessage != nil
    }

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        // font
        //label.font = FontFamily.Gilroy.medium.font(size: 12)
        return label
    }()

    private let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.layoutMargins = .equal(16)
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.distribution = .equalCentering
        vStack.alignment = .fill
        return vStack
    }()

    // MARK: - Lifecycle

    init(textField: UITextField) {
        self.textField = textField
        super.init(frame: .zero)
        addSubviewWithAnchorsToSuperView(stackView)
        layer.cornerRadius = 8
        backgroundColor = UIColor.white
        [titleLabel, textField].forEach {
            stackView.addArrangedSubview($0)
        }
        updateTitleVisibility()
        subscribeToEvents()
        setupGestureRecognizer()
    }

    override init(frame: CGRect) {
        fatalError("init(frame:) isn't supported")
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) isn't supported")
    }

    // MARK: - Implementation

    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FloatingLabelField.didTap))
        addGestureRecognizer(gestureRecognizer)
    }

    private func updateTitle() {
        titleLabel.text = errorMessage ?? title
        titleLabel.textColor = errorMessage != nil ? UIColor.red : UIColor.systemPink
    }

    private func subscribeToEvents() {
        textField.addTarget(self,
                            action: #selector(FloatingLabelField.editingChanged),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(FloatingLabelField.editingChanged),
                            for: .editingDidEnd)
    }

    @objc private func didTap() {
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        }
    }

    @objc private func editingChanged() {
        updateTitleVisibility()
    }

    private func updateTitleVisibility(animated: Bool = true) {
        let shouldHideTitle = !textField.isEditing || hasErrorMessage
        let curve = textField.isEditing ? UIView.AnimationCurve.easeIn : .easeOut
        let finalAlpha = shouldHideTitle ? CGFloat.zero : 1
        let finalTranslation = shouldHideTitle ? CGAffineTransform(translationX: 0, y: 8) : .identity
        titleLabel.isHidden = false
        let animator = UIViewPropertyAnimator(duration: 0.3,
                                              curve: curve) {
                                                self.titleLabel.alpha = finalAlpha
                                                self.titleLabel.transform = finalTranslation
        }
        animator.addAnimations({
            self.titleLabel.isHidden = shouldHideTitle
        }, delayFactor: 0.25)
        animator.startAnimation()
    }
}
