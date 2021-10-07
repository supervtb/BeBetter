import UIKit

open class KeyboardAwareTableView: UITableView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        enableKeyboardAwareness(true)
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        enableKeyboardAwareness(true)
    }

    override open func retrieveObservableView() -> UIView? {

        return observableView
    }

    override open func retrieveContentBottomView() -> UIView? {

        return contentBottomView
    }

    deinit {

        /*
         Just in case it hasn't been disabled yet
         */
        enableKeyboardAwareness(false)
    }

    // MARK: -

    @IBOutlet public weak var observableView: UIView?

    @IBOutlet public weak var contentBottomView: UIView?
}

