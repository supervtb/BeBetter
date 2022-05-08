import Combine
import Foundation

final class ResetPasswordViewModel: BaseViewModel {
    private(set) var email = PassthroughSubject<String, Never>()

    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        email
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    func resetPassword() {

    }
}
