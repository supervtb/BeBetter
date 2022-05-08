import Combine

open class BaseViewModel: ObservableObject {
    public var bag = Set<AnyCancellable>()
}
