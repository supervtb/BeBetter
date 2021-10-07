import UIKit

public extension UINavigationItem {

    func applyEmptyBack() {
        applyBack("")
    }

    func applyBack(_ title: String) {

        /*
         Set empty Back button title
         */
        let back = backBarButtonItem ?? UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        back.title = title
        backBarButtonItem = back
    }
}

