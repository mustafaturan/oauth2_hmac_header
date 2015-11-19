# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth2_hmac_header/version'

Gem::Specification.new do |spec|
  spec.name          = "oauth2_hmac_header"
  spec.version       = Oauth2HmacHeader::VERSION
  spec.authors       = ["Mustafa TURAN"]
  spec.email         = ["mustafaturan.net@gmail.com"]

  spec.summary       = %q{Authorization header generator, parser and validator Oauth v2 HTTP MAC authentication.}
  spec.description   = %q{Generate, parse and verify header information for oauth v2 http mac authentication.}
  spec.homepage      = "https://github.com/mustafaturan/oauth2_hmac_header"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "oauth2_hmac_sign", "~> 0.1.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end