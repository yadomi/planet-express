# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'planet/version'

Gem::Specification.new do |spec|
	spec.authors       = ["Felix Yadomi"]
	spec.email         = ["felix.yadomi@gmail.com"]

	spec.name          = "planet"
	spec.version       = Version::VERSION
	spec.summary       = %q{Ship any code with Planet Express}

	spec.files         = `git ls-files`.split($\)
	spec.executables   = ['planet']
	spec.require_paths = ["lib"]
	
	spec.add_dependency 'thor', '~> 0.19'
	spec.add_dependency 'gitable', '~> 0.3'

	spec.add_development_dependency "bundler", "~> 1.7"
	spec.add_development_dependency "rake", "~> 10.0"

end
