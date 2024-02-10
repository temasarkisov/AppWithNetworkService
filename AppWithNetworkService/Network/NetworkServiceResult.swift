import Foundation

struct NetworkServiceResult {
    let request: URLRequest
    let response: URLResponse?
    let data: Data?

    init(
        request: URLRequest,
        response: URLResponse?,
        data: Data?
    ) {
        self.request = request
        self.response = response
        self.data = data
    }
}
