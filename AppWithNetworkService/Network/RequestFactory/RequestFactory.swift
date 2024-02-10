import Foundation

protocol RequestFactory: AnyObject {
    func getRequest(
        endpoint: Endpoint
    ) throws -> URLRequest
}

final class RequestFactoryImpl: RequestFactory {
    private let hostConfiguration: HostConfiguration
    private let encoder = JSONEncoder()
    
    init(hostConfiguration: HostConfiguration) {
        self.hostConfiguration = hostConfiguration
    }
    
    func getRequest(endpoint: Endpoint) throws -> URLRequest {
        let baseRequest = try makeHTTPRequest(
            endpoint: endpoint,
            httpMethod: .get
        )
        
        let request = HeaderFormatter.applyJsonContentType(baseRequest)
        
        return request
    }
}

extension RequestFactoryImpl {
    private func makeHTTPRequest(
        endpoint: Endpoint,
        httpMethod: HTTPMethod,
        encodableEntity: Encodable? = nil
    ) throws -> URLRequest {
        guard let url = makeURL(endpoint: endpoint) else {
            throw NetworkError.invalideURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        switch httpMethod {
        case .post, .patch:
            request.httpBody = try? encodeParamsToData(encodableEntity: encodableEntity)
        default:
            break
        }

        return request
    }
    
    private func makeURL(endpoint: Endpoint) -> URL? {
        var components: URLComponents? = URLComponents(string: hostConfiguration.domain)
        components?.path = endpoint.path
        components?.queryItems = endpoint.queryItems
        
        return components?.url
    }
    
    private func encodeParamsToData(encodableEntity: Encodable?) throws -> Data? {
        guard let encodableEntity else {
            return nil
        }
        
        return try encoder.encode(encodableEntity)
    }
}
