import Foundation

struct HeaderFormatter {
    static func applyJsonContentType(_ request: URLRequest) -> URLRequest {
        var newRequest: URLRequest = request
        newRequest.setValue(
            "application/json; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        
        return newRequest
        
    }

    static func applyFormDataContentType(
        _ request: URLRequest,
        headeValue: String
    ) -> URLRequest {
        var newRequest: URLRequest = request
        newRequest.setValue(
            headeValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        return newRequest
    }
}
