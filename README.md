# DNSRobot

Official Swift client for [DNS Robot](https://dnsrobot.net) — 53 free online DNS and network tools.

Zero external dependencies.

## Install

### CocoaPods

```ruby
pod 'DNSRobot'
```

### Swift Package Manager

```swift
.package(url: "https://github.com/dnsrobot/dnsrobot-swift.git", from: "0.1.0")
```

## Usage

```swift
import DNSRobot

let client = DNSRobotClient()

// DNS lookup
client.dnsLookup(domain: "example.com") { result in
    switch result {
    case .success(let data): print(data)
    case .failure(let error): print(error)
    }
}

// WHOIS lookup
client.whoisLookup(domain: "example.com") { result in
    print(result)
}
```

## Available Methods

| Method | Description | Tool Page |
|--------|-------------|-----------|
| `dnsLookup` | DNS record lookup | [dnsrobot.net/dns-lookup](https://dnsrobot.net/dns-lookup) |
| `whoisLookup` | Domain registration data | [dnsrobot.net/whois-lookup](https://dnsrobot.net/whois-lookup) |
| `sslCheck` | SSL/TLS certificate check | [dnsrobot.net/ssl-checker](https://dnsrobot.net/ssl-checker) |
| `spfCheck` | SPF record validation | [dnsrobot.net/spf-checker](https://dnsrobot.net/spf-checker) |
| `dkimCheck` | DKIM record check | [dnsrobot.net/dkim-checker](https://dnsrobot.net/dkim-checker) |
| `dmarcCheck` | DMARC record check | [dnsrobot.net/dmarc-checker](https://dnsrobot.net/dmarc-checker) |
| `mxLookup` | MX record lookup | [dnsrobot.net/mx-lookup](https://dnsrobot.net/mx-lookup) |
| `nsLookup` | Nameserver lookup | [dnsrobot.net/ns-lookup](https://dnsrobot.net/ns-lookup) |
| `ipLookup` | IP geolocation | [dnsrobot.net/ip-lookup](https://dnsrobot.net/ip-lookup) |
| `httpHeaders` | HTTP response headers | [dnsrobot.net/http-headers-checker](https://dnsrobot.net/http-headers-checker) |
| `portCheck` | Port availability check | [dnsrobot.net/port-checker](https://dnsrobot.net/port-checker) |

## Links

- [DNS Robot](https://dnsrobot.net) — 53 free online DNS and network tools
- [All Tools](https://dnsrobot.net/all-tools)
- [GitHub](https://github.com/dnsrobot/dnsrobot-swift)

## License

MIT
