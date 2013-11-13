# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webio/version'

Gem::Specification.new do |spec|
  spec.name          = "webio"
  spec.version       = Webio::VERSION
  spec.authors       = ["Yoshihiro Kameda"]
  spec.email         = ["kameda.sbng@gmail.com"]
  spec.description   = %q{WebIO makes Web Server super easy!}
  spec.summary       = %q{A super easy Web Server library.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
