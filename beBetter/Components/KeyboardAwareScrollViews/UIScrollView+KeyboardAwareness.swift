import UIKit
import Foundation

public extension UIScrollView {

    /**
     Override this in an UIScrollView subclass to provide an observable view.
     The observable view is the view to autoscroll to on keyboard events.
     If no observable view is provided the first responder view is used instead
     */
    @objc func retrieveObservableView() -> UIView? {
        return nil
    }

    /**
     Override this in an UIScrollView subclass to provide an content bottom view.
     The content bottom view defines the bottom level of the content area which must be always observable.
     For example, you can limit the observable part of a scroll view's content area if it's too large
     */
    @objc func retrieveContentBottomView() -> UIView? {
        return nil
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

        guard var keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardRect = convert(keyboardRect, from: nil)

        /*
         Retrieve the scroll's bounds without the bottom safe area inset.
         That is the maximum possible custom scroll's inset
         */
        var maxScrollInsetArea = bounds
        maxScrollInsetArea.size.height -= safeAreaInsets.bottom

        /*
         Calculate piece of scroll view safe area that is covered by keyboard
         */
        let keyboardOverlap = keyboardRect.intersection(maxScrollInsetArea).height
        var scrollInset = keyboardOverlap

        /*
         Check if we have content "bottom" view specified, and if we do then reduce the scroll inset value so that
         we only be able to see the view, as opposed to the entire scroll view's content
         */
        if let contentBottomView = retrieveContentBottomView() {

            var contentBottomRect = convert(contentBottomView.bounds, from: contentBottomView)
            contentBottomRect.size.height += type(of: self).interactionOffset

            let contentMaxY = contentBottomRect.maxY
            let contentVDelta = contentSize.height - contentMaxY

            scrollInset -= contentVDelta

            if scrollInset < 0.0 {
                scrollInset = 0.0
            }
        }

        contentInset.bottom = scrollInset

        /*
         Apply the scroll indicator's inset
         */
        verticalScrollIndicatorInsets.bottom = keyboardOverlap

        /*
         Make sure the anchor view is visible, if it exists
         */
        guard let anchorView = retrieveObservableView() ?? findFirstResponderView() else { return }
        scrollTo(anchorView: anchorView, with: keyboardRect)
    }

    private func scrollTo(anchorView: UIView, with keyboardRect: CGRect) {

        var anchorRect = convert(anchorView.bounds, from: anchorView)
        anchorRect.size.height += type(of: self).interactionOffset//additional offset to the bottom of the anchor view

        var voffset = anchorRect.maxY - keyboardRect.minY
        if voffset < 0.0 {
            voffset = 0.0
        }

        var newContentOffset = contentOffset
        newContentOffset.y += voffset//intersection

        /*
         Make sure the new offset is in the total content area margins, ie not in the bounce area
         */
        let minContentOffset = -adjustedContentInset.top
        let maxContentOffset = (contentSize.height + adjustedContentInset.bottom) - bounds.height
        guard newContentOffset.y >= minContentOffset && newContentOffset.y <= maxContentOffset else { return }

        /*
         Make a little delay to allow the basic autoscrolling mechanism to work out
         */
        let now = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: now) {
            [weak self] in

            self?.setContentOffset(newContentOffset, animated: true)
        }
    }

    private static let interactionOffset = CGFloat(20.0)
}

/**
 First responder retriever
 */
private extension UIScrollView {

    func findFirstResponderView() -> UIView? {

        /*
         Traverse the receiver's subviews tree and find a first responder view.
         If the current first responder is not an UIView instance, or there is no first responder at all, return nil
         */
        let traverse = type(of: self).combY { (fff : @escaping (UIView) -> UIView?) -> ((UIView) -> UIView?) in

            return { (view: UIView) -> UIView? in

                var result: UIView?

                if view.isFirstResponder {

                    result = view
                } else {

                    for subview in view.subviews {

                        result = fff(subview)

                        if result != nil {

                            break
                        }
                    }
                }

                return result
            }
        }

        var result: UIView?

        for subview in subviews {

            result = traverse(subview)

            if result != nil {

                break
            }
        }

        return result
    }

    /*
     The Y combinator is a higher-order function. It takes a single argument, which is a function that isn’t recursive.
     It returns a version of the function, which is recursive.
     https://xiliangchen.wordpress.com/2014/08/04/recursive-closure-and-y-combinator-in-swift/
     */
    static func combY<T, R>(_ fff: @escaping ( @escaping (T) -> R) -> ((T) -> R) ) -> ((T) -> R) {
        return { (ttt: T) -> R in return fff(combY(fff))(ttt) }
    }
}

