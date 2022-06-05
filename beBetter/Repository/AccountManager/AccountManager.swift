import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift



public protocol AccountManagerType: Any {

    var authenticationState: PassthroughSubject<User?, Error> { get }

    func doSignIn(email: String, password: String)

    func doSignUp(email: String, password: String)
}

final class AccountManager: AccountManagerType {

    let authenticationState = PassthroughSubject<User?, Error>()

    var bag = Set<AnyCancellable>()

    private let authService: Auth = Auth.auth()

    func doSignIn(email: String, password: String) {
        authService.signIn(withEmail: email, password: password)
            .sink { [weak self ] completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error):
                    self?.authenticationState.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] user in
                self?.authenticationState.send(UserImpl(userId: user.user.uid, userName: user.user.email ?? ""))
            }.store(in: &bag)
    }

    func doSignUp(email: String, password: String) {
        authService.createUser(withEmail: email, password: password)
            .sink { [weak self] completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error):
                    self?.authenticationState.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] user in
                self?.authenticationState.send(UserImpl(userId: user.user.uid, userName: user.user.email ?? ""))
            }.store(in: &bag)
    }
}
