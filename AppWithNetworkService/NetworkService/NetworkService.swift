import Foundation

public protocol NetworkService {
    func request<Request: NetworkRequest>(
        _ request: Request,
        queue: DispatchQueue,
        completion: @escaping (Result<Request.Response, Error>) -> Void
    )
}

public class NetworkServiceImpl: NetworkService {
    public func request<Request: NetworkRequest>(
        _ request: Request,
        queue: DispatchQueue,
        completion: @escaping (Result<Request.Response, Error>) -> Void
    ) {
        guard let url = url(from: request) else {
            queue.async {
                completion(.failure(ResponseError.notFound))
            }
            
            return
        }
        
        let urlRequest = makeURLRequest(
            url: url,
            request: request
        )
        
        let dataTaskHandler = dataTaskHandler(
            request: request,
            queue: .main,
            completion: completion
        )
        
        URLSession.shared
            .dataTask(
                with: urlRequest,
                completionHandler: dataTaskHandler
            )
            .resume()
    }
}

extension NetworkServiceImpl {
    private func url<Request: NetworkRequest>(from request: Request) -> URL? {
        guard var urlComponent = URLComponents(string: request.url) else {
            return nil
        }
        
        let urlQueryItems: [URLQueryItem] = request.queryItems.map {
            URLQueryItem(
                name: $0.key,
                value: $0.value
            )
        }
        
        urlComponent.queryItems?.append(contentsOf: urlQueryItems)
        urlComponent.queryItems = urlQueryItems
        
        return urlComponent.url
    }
    
    private func makeURLRequest<Request: NetworkRequest>(
        url: URL,
        request: Request
    ) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        if request.body.isEmpty == false {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.body)
        }
        
        return urlRequest
    }
    
    private func dataTaskHandler<Request: NetworkRequest>(
        request: Request,
        queue: DispatchQueue,
        completion: @escaping (Result<Request.Response, Error>) -> Void
    ) ->(Data?, URLResponse?, Error?) -> Void {
        return { (data, response, error) -> Void in
            if let error = error {
                queue.async {
                    completion(.failure(error))
                }
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                queue.async {
                    completion(.failure(ResponseError.badRequest))
                }
                
                return
            }
            
            guard let data = data else {
                queue.async {
                    completion(.failure(ResponseError.badRequest))
                }
                
                return
            }
            
            queue.async {
                do {
                    try completion(.success(request.decode(data)))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
}
