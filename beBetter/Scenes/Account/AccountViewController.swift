import UIKit
import Combine

final class AccountViewController: BaseViewController, CustomLoadedController {

    let completedSubject = PassthroughSubject<Bool, Never>()

    let logoutSubject = PassthroughSubject<Bool, Never>()

    private var bag = Set<AnyCancellable>()

    typealias ViewType = AccountView

    weak var coordinator: MainCoordinator?

    private let tab: Tab

    private lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Logout",
                                     image: nil, primaryAction: UIAction(handler: { [unowned self] _ in
            self.logoutSubject.send(true)
        }))

        return button
    }()

    public init(tab: Tab) {
        self.tab = tab
        super.init()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = AccountView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = logoutButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = tab.title
    }
}
