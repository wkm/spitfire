# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spitfire/version'

Gem::Specification.new do |gem|
  gem.name          = "spitfire"
  gem.version       = Spitfire::VERSION
  gem.authors       = ["Wiktor Macura"]
  gem.email         = ["wiktor@tumblr.com"]
  gem.description   = %q{ultra lightweight, encryption free directory transfer}
  gem.summary       = %q{ultra lightweight, encryption free directory transfer}
  gem.homepage      = "github.com/wkm/spitfire"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.dependency 'net-ssh'
  gem.dependency 'highline'
  gem.dependency 'thor'
end
