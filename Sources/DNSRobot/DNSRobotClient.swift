import Foundation

/// Official Swift client for [DNS Robot](https://dnsrobot.net).
///
/// Provides DNS lookups, WHOIS, SSL checks, and network tools.
///
/// ```swift
/// let client = DNSRobotClient()
/// client.dnsLookup(domain: "example.com") { result in
///     print(result)
/// }
/// ```
public class DNSRobotClient {
    private let baseURL: String
    private let userAgent = "dnsrobot-swift/0.1.0"
    private let session: URLSession

    /// Creates a new DNS Robot client.
    ///
    /// - Parameter baseURL: API base URL (default: `https://dnsrobot.net/api`)
    public init(baseURL: String = "https://dnsrobot.net/api") {
        self.baseURL = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        self.session = URLSession.shared
    }

    // MARK: - Public Methods

    /// DNS record lookup.
    ///
    /// See [dnsrobot.net/dns-lookup](https://dnsrobot.net/dns-lookup)
    public func dnsLookup(
        domain: String,
        recordType: String = "A",
        dnsServer: String = "8.8.8.8",
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "dns-query", body: [
            "domain": domain,
            "recordType": recordType,
            "dnsServer": dnsServer,
        ], completion: completion)
    }

    /// WHOIS domain registration lookup.
    ///
    /// See [dnsrobot.net/whois-lookup](https://dnsrobot.net/whois-lookup)
    public func whoisLookup(
        domain: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "whois", body: ["domain": domain], completion: completion)
    }

    /// SSL/TLS certificate check.
    ///
    /// See [dnsrobot.net/ssl-checker](https://dnsrobot.net/ssl-checker)
    public func sslCheck(
        domain: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "ssl-certificate", body: ["domain": domain], completion: completion)
    }

    /// SPF record validation.
    ///
    /// See [dnsrobot.net/spf-checker](https://dnsrobot.net/spf-checker)
    public func spfCheck(
        domain: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "spf-checker", body: ["domain": domain], completion: completion)
    }

    /// DKIM record check.
    ///
    /// See [dnsrobot.net/dkim-checker](https://dnsrobot.net/dkim-checker)
    public func dkimCheck(
        domain: String,
        selector: String? = nil,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        var body: [String: String] = ["domain": domain]
        if let selector = selector { body["selector"] = selector }
        post(endpoint: "dkim-checker", body: body, completion: completion)
    }

    /// DMARC record check.
    ///
    /// See [dnsrobot.net/dmarc-checker](https://dnsrobot.net/dmarc-checker)
    public func dmarcCheck(
        domain: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "dmarc-checker", body: ["domain": domain], completion: completion)
    }

    /// MX record lookup.
    ///
    /// See [dnsrobot.net/mx-lookup](https://dnsrobot.net/mx-lookup)
    public func mxLookup(
        domain: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "mx-lookup", body: ["domain": domain], completion: completion)
    }

    /// Nameserver lookup.
    ///
    /// See [dnsrobot.net/ns-lookup](https://dnsrobot.net/ns-lookup)
    public func nsLookup(
        domain: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "ns-lookup", body: ["domain": domain], completion: completion)
    }

    /// IP geolocation lookup.
    ///
    /// See [dnsrobot.net/ip-lookup](https://dnsrobot.net/ip-lookup)
    public func ipLookup(
        ip: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        post(endpoint: "ip-info", body: ["ip": ip], completion: completion)
    }

    /// HTTP response headers check.
    ///
    /// See [dnsrobot.net/http-headers-checker](https://dnsrobot.net/http-headers-checker)
    public func httpHeaders(
        url: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        let fullURL = (url.hasPrefix("http://") || url.hasPrefix("https://")) ? url : "https://\(url)"
        post(endpoint: "http-headers", body: ["url": fullURL], completion: completion)
    }

    /// Port availability check.
    ///
    /// See [dnsrobot.net/port-checker](https://dnsrobot.net/port-checker)
    public func portCheck(
        host: String,
        port: Int,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/port-check?host=\(host)&port=\(port)") else {
            completion(.failure(DNSRobotError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(.failure(DNSRobotError.invalidResponse))
                return
            }
            completion(.success(json))
        }.resume()
    }

    // MARK: - Private

    private func post(
        endpoint: String,
        body: [String: String],
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            completion(.failure(DNSRobotError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(.failure(DNSRobotError.invalidResponse))
                return
            }
            completion(.success(json))
        }.resume()
    }
}

/// Errors returned by DNSRobotClient.
public enum DNSRobotError: Error, LocalizedError {
    case invalidURL
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response from server"
        }
    }
}
