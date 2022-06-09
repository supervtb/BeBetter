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
            self.logoutDidTap()
        }))
        return button
    }()

    public init(tab: Tab, viewModel: BaseViewModel) {
        self.tab = tab
        super.init(viewModel: viewModel)
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

        guard let viewModel = viewModel as? AccountViewModel else {
            fatalError()
        }

        viewModel.didLogout.sink { _ in
            self.logoutSubject.send(true)
        }.store(in: &bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = tab.title
    }

    func logoutDidTap() {
        guard let viewModel = viewModel as? AccountViewModel else {
            fatalError()
        }

        viewModel.handleLogoutAction.send()
    }
}
