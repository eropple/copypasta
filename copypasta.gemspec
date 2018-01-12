
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "copypasta/version"

Gem::Specification.new do |spec|
  spec.name          = "copypasta"
  spec.version       = Copypasta::VERSION
  spec.authors       = ["Ed Ropple"]
  spec.email         = ["ed@edropple.com"]

  spec.summary       = "A file and directory scaffolder for Ruby."
  spec.homepage      = "https://github.com/eropple/copypasta"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "tilt", "~> 2.0"
  spec.add_runtime_dependency "cri-scaffold", "~> 0.1"
  spec.add_runtime_dependency "highline", "~> 1.7"
end
