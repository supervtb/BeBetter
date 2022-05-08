import UIKit
import Combine

final class HomeViewController: BaseViewController, CustomLoadedController {

    let completedSubject = PassthroughSubject<Bool, Never>()

    private var bag = Set<AnyCancellable>()

    typealias ViewType = HomeView

    weak var coordinator: MainCoordinator?

    private let tab: Tab

    public init(tab: Tab) {
        self.tab = tab
        super.init()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = tab.title
    }

    private func setupData() {
        _view.tableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "HomeTableViewCell", for: indexPath
        ) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "Test title"
        return cell
    }
}
