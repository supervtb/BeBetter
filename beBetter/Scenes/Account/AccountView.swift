import UIKit

final class AccountView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        preservesSuperviewLayoutMargins = true
        backgroundColor = UIColor(.backgroundPrimary)
    }
}

