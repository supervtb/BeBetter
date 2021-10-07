import UIKit

public enum TextSize {

    public static func size(_ text: String,
                            font: UIFont,
                            width: CGFloat,
                            insets: UIEdgeInsets = UIEdgeInsets.zero,
                            calculateWidth: Bool = false,
                            paragraphStyle: NSParagraphStyle = NSParagraphStyle()) -> CGRect {

        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [ NSAttributedString.Key.font: font, .paragraphStyle: paragraphStyle ]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = (text as NSString).boundingRect(with: constrainedSize,
                                                     options: options,
                                                     attributes: attributes,
                                                     context: nil)

        if calculateWidth {
            bounds.size.width = ceil(bounds.width + insets.left + insets.right)
        } else {
            bounds.size.width = width
        }

        bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        return bounds
    }

    public static func size(_ text: String,
                            font: UIFont,
                            height: CGFloat,
                            insets: UIEdgeInsets = UIEdgeInsets.zero,
                            calculateHeight: Bool = false,
                            paragraphStyle: NSParagraphStyle = NSParagraphStyle()) -> CGRect {

        let constrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                     height: height - insets.top - insets.bottom)
        let attributes = [ NSAttributedString.Key.font: font, .paragraphStyle: paragraphStyle ]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = (text as NSString).boundingRect(with: constrainedSize,
                                                     options: options,
                                                     attributes: attributes,
                                                     context: nil)

        if calculateHeight {
            bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        } else {
            bounds.size.height = height
        }

        bounds.size.width = ceil(bounds.width + insets.left + insets.right)
        return bounds
    }
}

