
#lib = File.expand_path("../lib", __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require "fluent/plugin/filter_imds/version"

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-filter_imds"
  spec.version       = "0.0.1"
  spec.authors       = ["Matt Juel "]
  spec.email         = ["v-majuel@microsoft"]

  spec.summary       = %q{Filter plugin to add Azure IMDS metadata to logs emitted}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/juelm/fluent-plugin-filter_addimdsmetadata"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "test-unit"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
end
