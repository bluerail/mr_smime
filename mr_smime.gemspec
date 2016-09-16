# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mr_smime/version'

Gem::Specification.new do |spec|
  spec.name          = 'mr_smime'
  spec.version       = MrSmime::VERSION
  spec.authors       = ['Rene van Lieshout']
  spec.email         = ['rene@bluerail.nl']

  spec.summary       = 'Secure/Multipurpose Internet Mail Extensions (S/MIME) support for ActionMailer'
  spec.homepage      = ''

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'mail', '>= 2.1.2' # register_interceptor
end
