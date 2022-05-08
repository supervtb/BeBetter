import UIKit

public extension UIFont {

    enum FontName: String {

        case gilroyBold = "Gilroy-Bold"

        case gilroyRegular = "Gilroy-Regular"
    }

    static func customFont(name: FontName, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
