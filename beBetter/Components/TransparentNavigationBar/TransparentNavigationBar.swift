import UIKit

public class TransparentNavigationBar: UINavigationBar {

    // MARK: -

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: -

    private func setup() {

        /*
         Transparency
         */
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true

        /*
         Other
         */
        let baseColor = UIColor(.blackColor)
        tintColor = baseColor
//        prefersLargeTitles = true

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: baseColor]
        titleTextAttributes = attributes
    }
}

