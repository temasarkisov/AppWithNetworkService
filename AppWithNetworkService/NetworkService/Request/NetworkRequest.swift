import Foundation

public protocol NetworkRequest {
    associatedtype Response
    
    var url: String { get }
    var method: RequestMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    var body: [String: Any] { get }
    
    func decode(_ data: Data) throws -> Response
}

extension NetworkRequest {
    public var headers: [String : String] { [:] }
    public var queryItems: [String : String] { [:] }
    public var body: [String : Any] { [:] }
}

extension NetworkRequest where Response: Decodable {
    public func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
