# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delivery_center/version'

Gem::Specification.new do |spec|
  spec.name          = "delivery_center"
  spec.version       = DeliveryCenter::VERSION
  spec.authors       = ["Takatoshi Maeda"]
  spec.email         = ["me@tmd.tw"]

  spec.summary       = %q{deploy management}
  spec.description   = %q{deploy management}
  spec.homepage      = "https://github.com/tokubai/delivery_center"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "activerecord"
  spec.add_dependency "mysql2"
  spec.add_dependency "ridgepole"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.6.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec-json_matcher"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "database_rewinder"
end
