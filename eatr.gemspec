# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eatr/version'

Gem::Specification.new do |spec|
  spec.name          = "eatr"
  spec.version       = Eatr::VERSION
  spec.authors       = ["Greggory Rothmeier"]
  spec.email         = ["greggroth@gmail.com"]

  spec.summary       = %q{Config-based ETL}
  spec.description   = %q{Config-based ETL}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~>0.10"
end
