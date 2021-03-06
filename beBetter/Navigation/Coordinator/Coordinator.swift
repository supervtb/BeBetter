import UIKit
import Combine

public protocol Coordinator: class, RoutableProtocol {

    associatedtype CoordinationResult

    var router: Router { get }

    var identifier: UUID { get }

    var dependencies: DependencyContainer { get }

    func start() -> AnyPublisher<CoordinationResult, Never>
}

// MARK: BaseCoordinator
open class BaseCoordinator<Result>: NSObject, Coordinator {

    public let identifier = UUID()

    private var childCoordinators = [UUID: Any]()

    public var bag = Set<AnyCancellable>()

    public let router: Router

    public var dependencies: DependencyContainer

    public var source: UIViewController {
        fatalError("must override this")
    }

    init(
        presenting navigationController: NavigationControllerReleaseHandler,
        dependencies: DependencyContainer = DefaultDependencyContainer()
    ) {
        self.dependencies = dependencies
        self.router = Router(navigationController: navigationController)
    }

    /// store coordinator by identifier
    private func store<C: Coordinator>(_ coordinator: C) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// release coordinator
    private func free<C: Coordinator>(_ coordinator: C) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }

    /// call start method of the coordinator to observe returned events. clear coordinator from memory if emits an output
    public func coordinate<C: Coordinator, U>(to coordinator: C) -> AnyPublisher<U, Never> where U == C.CoordinationResult {

        store(coordinator)

        return coordinator.start()
            .prefix(1)
            .handleEvents(receiveOutput: { _ in
                self.free(coordinator)
            })
            .eraseToAnyPublisher()

    }

    /// push source view controller of the coordinator into navgation stack. observe poped event
    /// to release coordinator from memory and complete action
    public func push<C: Coordinator, U>(to coordinator: C, animated: Bool = true) -> AnyPublisher<U, Never> where U == C.CoordinationResult {
        let poped = router.push(coordinator, animated: animated)
            .handleEvents(receiveCompletion: { _ in
                self.free(coordinator)
            }).eraseToAnyPublisher()

        return  coordinate(to: coordinator).take(until: poped)
            .flatMap({ value -> AnyPublisher<U, Never> in
                return self.router.pop(coordinator)
                    .map { value }
                    .replaceEmpty(with: value)
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }

    /// present source view controller of the coordinator into navgation stack. observe dismissed event
    ///  to release coordinator from memory and complete action
    public func present<C: Coordinator, U>(to coordinator: C, animated: Bool = true) -> AnyPublisher<U, Never> where U == C.CoordinationResult {
        let dismissed = router.present(coordinator, animated: animated)
            .handleEvents(receiveCompletion: { _ in
                self.free(coordinator)
            })
            .eraseToAnyPublisher()

        return coordinate(to: coordinator).take(until: dismissed)
            .flatMap({ value -> AnyPublisher<U, Never> in
                return self.router.dismiss(coordinator)
                    .replaceEmpty(with: value)
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }

    // set source view controller of the coordinator into navigation stack
    public func set<C: Coordinator, U>(to coordinator: C, animated: Bool = true) -> AnyPublisher<U, Never> where U == C.CoordinationResult {

        let result = coordinate(to: coordinator)

        router.setViewController(coordinator, animated: animated)

        return result.eraseToAnyPublisher()
    }

    /// set source view controller of the coordinator as root view controller
    public func setRoot<C: Coordinator, U>(
        to coordinator: C,
        into window: UIWindow,
        animated: Bool = true
    ) -> AnyPublisher<U, Never> where U == C.CoordinationResult {

        let result = coordinate(to: coordinator)

        router.setRootViewController(coordinator,
                                     into: window,
                                     animated: animated)

        return result.eraseToAnyPublisher()
    }

    /// configure events
    open func start() -> AnyPublisher<Result, Never> {
        fatalError("must override this")
    }
}
