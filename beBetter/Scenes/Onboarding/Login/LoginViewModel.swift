import Combine
import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift

final class LoginViewModel: BaseViewModel {

    private let accountManagerProvider: AccountManagerType

    private let userDefaultsProvider: UserDefaultsManager

    private(set) var email = CurrentValueSubject<String, Never>("")

    private(set) var password = CurrentValueSubject<String, Never>("")

    let isSuccess = PassthroughSubject<Void, Never>()
    
    let isError = PassthroughSubject<String, Never>()

    let isNetworkLoading = CurrentValueSubject<Bool, Never>(false)

    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        email
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    var isLoginValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher).map { isEmail, isPassword in
            return isEmail && isPassword
        }
        .eraseToAnyPublisher()
    }

    init(accountProvider: AccountManagerType, userDefaultsProvider: UserDefaultsManager ) {
        self.accountManagerProvider = accountProvider
        self.userDefaultsProvider = userDefaultsProvider
        super.init()
        self.setObservers()

    }

    private func setObservers() {
        accountManagerProvider.authenticationState.sink { _ in } receiveValue: { [weak self] state in
            self?.isNetworkLoading.send(false)
            switch state {
            case .none(let error):
                self?.isError.send(error)
            case .user(_):
                self?.userDefaultsProvider.updateLoginState(isLogged: true)
                self?.isSuccess.send()
            }
        }.store(in: &bag)
    }

    func doLogin() {
        isNetworkLoading.send(true)
        accountManagerProvider.doSignIn(email: email.value, password: password.value)
    }
}
