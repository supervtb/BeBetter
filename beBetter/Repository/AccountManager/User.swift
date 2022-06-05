public protocol User {

    var userId: String { get }

    var userName: String { get }
}

public struct UserImpl: User {

    public var userId: String
    
    public var userName: String

    init(userId: String, userName: String) {
        self.userId = userId
        self.userName = userName
    }
}
