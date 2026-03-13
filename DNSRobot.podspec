Pod::Spec.new do |s|
  s.name         = 'DNSRobot'
  s.version      = '0.1.0'
  s.summary      = 'Official Swift client for DNS Robot — DNS lookups, WHOIS, SSL checks, and network tools.'
  s.description  = <<-DESC
    Official Swift client for DNS Robot (dnsrobot.net). Provides DNS lookups,
    WHOIS queries, SSL certificate checks, SPF/DKIM/DMARC validation, MX/NS
    lookups, IP geolocation, HTTP headers analysis, and port checking.
    Zero external dependencies.
  DESC
  s.homepage     = 'https://dnsrobot.net'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'DNS Robot' => 'hello@dnsrobot.net' }
  s.source       = { :git => 'https://github.com/dnsrobot/dnsrobot-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'

  s.swift_versions = ['5.0']
  s.source_files = 'Sources/DNSRobot/**/*.swift'
end
