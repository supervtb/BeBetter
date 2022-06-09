import Combine
import Foundation

final class SignUpViewModel: BaseViewModel {

    private let accountManagerProvider: AccountManagerType

    private let userDefaultsProvider: UserDefaultsManager

    private(set) var email = CurrentValueSubject<String, Never>("")

    private(set) var password = CurrentValueSubject<String, Never>("")

    private(set) var confirmPassword = CurrentValueSubject<String, Never>("")

    let isSuccess = PassthroughSubject<Void, Never>()

    let isError = PassthroughSubject<String, Never>()

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

    private var isPasswordsMatchesPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(password, confirmPassword)
            .map { password, repeated in
                return password == repeated
            }
            .eraseToAnyPublisher()
    }

    private var isConfirmPasswordValidPublisher: AnyPublisher<Bool, Never> {
        confirmPassword
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    var isSignUpValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            isEmailValidPublisher,
            isPasswordValidPublisher,
            isConfirmPasswordValidPublisher,
            isPasswordsMatchesPublisher
        )
        .map { isEmail, isPassword, isConfirmPassword, isPasswordsMarched in
            return isEmail && isPassword && isConfirmPassword && isPasswordsMarched
        }
        .eraseToAnyPublisher()
    }

    init(accountProvider: AccountManagerType, userDefaultsProvider: UserDefaultsManager) {
        self.accountManagerProvider = accountProvider
        self.userDefaultsProvider = userDefaultsProvider
        super.init()
        self.setObservers()

    }

    private func setObservers() {
        accountManagerProvider.authenticationState.sink { _ in } receiveValue: { state in
            switch state {
            case .none(let error):
                self.isError.send(error)
            case .user(_):
                self.userDefaultsProvider.updateLoginState(isLogged: true)
                self.isSuccess.send()
            }
        }.store(in: &bag)
    }

    func doSignUp() {
        accountManagerProvider.doSignUp(email: email.value, password: password.value)
    }
}
