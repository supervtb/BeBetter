import Combine
import Foundation

final class LoginViewModel: BaseViewModel {
    private(set) var email = PassthroughSubject<String, Never>()
    private(set) var password = PassthroughSubject<String, Never>()

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

    func signIn() {

    }
}
