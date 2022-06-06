import Foundation
enum Step: Hashable, Equatable {
    case loggedIn
    case loggedOut
    case signUp
    case signUpEnded
    case signUpCanceled
    case resetPassword
    case resetPasswordEnded
    case resetPasswordCanceled
    case alert(AlertConfiguration<DefaultAlertAction>)

    static func == (lhs: Step, rhs: Step) -> Bool {
        switch (lhs, rhs) {
        case (let .alert(config1), let .alert(config2)):
            return config1.title == config2.title
        default:
            return lhs.hashValue == rhs.hashValue
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .loggedIn:
            hasher.combine(0)
        case .loggedOut:
            hasher.combine(1)
        case .signUp:
            hasher.combine(2)
        case .signUpEnded:
            hasher.combine(3)
        case .signUpCanceled:
            hasher.combine(4)
        case .resetPassword:
            hasher.combine(5)
        case .resetPasswordEnded:
            hasher.combine(6)
        case .resetPasswordCanceled:
            hasher.combine(7)
        case .alert:
            hasher.combine(8)
        }
    }
}
