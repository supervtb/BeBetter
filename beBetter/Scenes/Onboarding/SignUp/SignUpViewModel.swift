import Combine
import Foundation

final class SignUpViewModel: BaseViewModel {
    private(set) var email = PassthroughSubject<String, Never>()
    private(set) var password = PassthroughSubject<String, Never>()
    private(set) var confirmPassword = PassthroughSubject<String, Never>()

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

    func signUp() {

    }
}
