import Foundation

struct HostConfiguration {
    var domain: String {
        "\(scheme)://\(host)"
    }

    let scheme: String
    let host: String

    init(
        scheme: String,
        host: String
    ) {
        self.scheme = scheme
        self.host = host
    }
}
