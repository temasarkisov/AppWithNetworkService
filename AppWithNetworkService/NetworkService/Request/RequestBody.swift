import Foundation

public protocol RequestBody {
    func encode() throws -> [String: Any]
}

extension RequestBody where Self: Encodable {
    public func encode() throws -> [String: Any] {
        let jsonData = try JSONEncoder().encode(self)
        return ((try JSONSerialization.jsonObject(
            with: jsonData,
            options: []
        )) as? [String: Any]) ?? [:]
    }
}
