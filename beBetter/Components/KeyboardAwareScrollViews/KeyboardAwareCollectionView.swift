import UIKit

open class KeyboardAwareCollectionView: UICollectionView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        enableKeyboardAwareness(true)
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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

