import Foundation

enum Endpoint: String {
    // MARK: Auth
    case signIn = "/auth/sign-in"
}

extension Endpoint {
    var absolutePath: String {
        Secret.host + self.rawValue
    }

    func absolutePath(id: Int) -> String {
        absolutePath + "/\(id)"
    }
}
