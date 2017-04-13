# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sigmund/version'

Gem::Specification.new do |spec|
  spec.name          = "sigmund"
  spec.version       = Sigmund::VERSION
  spec.authors       = ["Belighted"]
  spec.email         = ["info@belighted.com"]

  spec.summary       = %q{Easily fetch projects details fro different providers}
  spec.description   = %q{Easily fetch projects details fro different providers.}
  spec.homepage      = "https://github.com/belighted/sigmund"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9.0"
  spec.add_dependency "faraday_middleware", "~> 0.11.0"
  spec.add_dependency "activesupport", "~> 5.0.2"
  spec.add_dependency "oauth2", "~> 1.3.1"
  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_dependency 'octokit', '~> 4.7'
  spec.add_dependency 'tracker_api', '~> 1.6'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.48.1"
  spec.add_development_dependency 'rails', '~> 5.0.1'
  spec.add_development_dependency 'sqlite3'

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.3.2"
  spec.add_development_dependency 'combustion', '~> 0.6.0'
end
