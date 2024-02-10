import Foundation

public protocol RequestQueryParams {
    func encode() throws -> [String: String]
}

extension RequestQueryParams where Self: Encodable {
    public func encode() throws -> [String: String] {
        let jsonData = try JSONEncoder().encode(self)
        return ((try JSONSerialization.jsonObject(
            with: jsonData,
            options: []
        )) as? [String: String]) ?? [:]
    }
}
