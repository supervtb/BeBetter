//
//  BeBetterAlertTextModifier.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import UIKit



enum BeBetterAlertTextModifier: AlertTextModifier {

    case title, message, errorTitle, custom((String) -> NSAttributedString)

    func makeAttributedString(from originalString: String) -> NSAttributedString {
        switch self {
        case .title:
            return NSAttributedString(string: originalString,
                                      attributes: [.foregroundColor: UIColor(.blackColor),
                                                   .font: UIFont.customFont(name: .gilroyBold, size: 28) as Any])
        case .message:
            return NSAttributedString(string: originalString,
                                      attributes: [.foregroundColor: UIColor(.blackColor),
                                                   .font: UIFont.customFont(name: .gilroyRegular, size: 16) as Any])
        case .errorTitle:
            return NSAttributedString(string: originalString,
                                      attributes: [.foregroundColor: UIColor(.pinkishGrey),
                                                   .font: UIFont.customFont(name: .gilroyBold, size: 28) as Any])
        case .custom(let transform):
            return transform(originalString)
        }
    }
}
