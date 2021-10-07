import UIKit
import Foundation

open class KeyboardAwareScrollContainerView: UIView {

    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.preservesSuperviewLayoutMargins = true
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addScrollView()
        enableKeyboardAwareness(true)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addScrollView()
        enableKeyboardAwareness(true)
    }

    func addScrollView() {
        addSubview(scrollView, constraints: [
            equal(\.topAnchor),
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.widthAnchor),
            equal(\.heightAnchor),
            equal(\.bottomAnchor)
        ])
    }

    deinit {

        /*
         Just in case it hasn't been disabled yet
         */
        enableKeyboardAwareness(false)
    }

    /**
     - Important: The awareness MUST be disabled up to the receiver's deinit
     */
    func enableKeyboardAwareness(_ enable: Bool) {

        /*
         Enable/disable keyboard notifications handling
         */
        let notificationCenter = NotificationCenter.default
        let willChange = UIResponder.keyboardWillChangeFrameNotification

        if enable {

            notificationCenter.addObserver(self,
                                           selector: #selector(keyboardWillChangeFrame(notification:)),
                                           name: willChange,
                                           object: nil)
        } else {

            notificationCenter.removeObserver(self, name: willChange, object: nil)
        }
    }

    // MARK: -

    @objc private func keyboardWillChangeFrame(notification: Notification) {

        if self.window == nil {
            return
        }

        guard let info = notification.userInfo else {
            return
        }

        guard var keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let animationCurve = (info[UIResponder.keyboardAnimationCurveUserInfoKey]) as? Int
        else {
            return
        }
        keyboardRect = convert(keyboardRect, from: nil)
        let intersection = keyboardRect.intersects(self.bounds)
        let keyboardHeight = intersection ? keyboardRect.height - safeAreaInsets.bottom : 0
        animateChanges(keyboardHeight: keyboardHeight)
        let curve = UIView.AnimationCurve.init(rawValue: animationCurve) ?? UIView.AnimationCurve.linear
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        let keyboardAnimator = UIViewPropertyAnimator(duration: animationDuration,
                                                      curve: curve) {
                                                        self.layoutIfNeeded()
        }
        keyboardAnimator.startAnimation()
    }

    func animateChanges(keyboardHeight: CGFloat) {}
}

