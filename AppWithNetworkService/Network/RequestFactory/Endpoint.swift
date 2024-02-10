import Foundation

struct Endpoint {
    public let path: String
    public let queryItems: [URLQueryItem]

    public init(
        path: String,
        queryItems: [URLQueryItem] = []
    ) {
        self.path = path
        self.queryItems = queryItems
    }
}
