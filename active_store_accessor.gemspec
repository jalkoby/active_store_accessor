# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "active_store_accessor"
  spec.version       = "0.2.1"
  spec.authors       = ["Sergey Pchelincev"]
  spec.email         = ["mail@sergeyp.me"]
  spec.summary       = %q{Get more from ActiveRecord::Store}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 4.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", ">= 4.7"
end
