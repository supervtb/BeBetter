import UIKit

protocol CustomLoadedController: UIViewController {

    associatedtype ViewType: UIView

    var _view: ViewType { get }
}

extension CustomLoadedController {

    var _view: ViewType {
        guard let view = view as? ViewType else {
            fatalError("""
                Wrong view setup. Expected "\(String(describing: ViewType.self))" \
                but found "\(String(describing: self.view.self)) instead"
            """)
        }
        return view
    }
}
