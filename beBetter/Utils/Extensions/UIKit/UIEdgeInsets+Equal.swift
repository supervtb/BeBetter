import struct UIKit.UIEdgeInsets
import struct UIKit.CGFloat

extension UIEdgeInsets {

    static func equal(_ size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
}

