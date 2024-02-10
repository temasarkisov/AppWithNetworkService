import Foundation

enum ResponseError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case `internal` = 500
}
