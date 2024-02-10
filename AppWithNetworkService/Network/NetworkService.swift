import Foundation

protocol NetworkService: AnyObject {
    func execute(request: URLRequest) async throws -> NetworkServiceResult
}

final class NetworkServiceImpl: NetworkService {
    public func execute(
        request: URLRequest
    ) async throws -> NetworkServiceResult {
        let (data, response) = try await URLSession.shared.data(for: request)

        return NetworkServiceResult(
            request: request,
            response: response,
            data: data
        )
    }
}
