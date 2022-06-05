import Combine
import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift

final class LoginViewModel: BaseViewModel {

    let accountManagerProvider: AccountManagerType

    private(set) var email = CurrentValueSubject<String, Never>("")

    private(set) var password = CurrentValueSubject<String, Never>("")

    let isSuccess = PassthroughSubject<Void, Never>()
    
    let isError = PassthroughSubject<Void, Never>()

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

    init(accountProvider: AccountManagerType) {
        self.accountManagerProvider = accountProvider
        super.init()
        self.setObservers()

    }

    private func setObservers() {
        accountManagerProvider.authenticationState.sink { error in
            self.isError.send()
        } receiveValue: { user in
            self.isSuccess.send()
        }.store(in: &bag)
    }

    func doLogin() {
        accountManagerProvider.doSignIn(email: email.value, password: password.value)
    }
}
