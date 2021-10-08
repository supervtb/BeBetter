import UIKit

final class LoginViewController: UIViewController, CustomLoadedController {
    
    typealias ViewType = LoginView

    weak var coordinator: MainCoordinator?

    override func loadView() {
        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        _view.onLogin = {
            print("login")
        }
    }
}
