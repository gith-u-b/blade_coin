
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "blade/coin/version"
require 'bundler/setup'
require 'bundler/version'

Gem::Specification.new do |spec|
  spec.name          = "blade_coin"
  spec.version       = Blade::Coin::VERSION
  spec.authors       = ["sai"]
  spec.email         = ["rubyer1993@gmail.com"]

  spec.summary       = "A cryptocurrency price monitoring tool"
  spec.description   = "A cryptocurrency price monitoring tool, you can run 'coin -h' for more help, or read the 'README.md'."
  spec.homepage      = "https://github.com/gith-u-b/blade_coin"
  spec.license       = "MIT"
  if Gem::Version.new(Bundler::VERSION) >= Gem::Version.new('2.0.0')
    spec.add_dependency 'rainbow', "~> 3.1"
  else
    spec.add_dependency 'rainbow', "~> 2.1"
  end
  spec.add_dependency 'terminal-table', '~> 1.8'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if Gem::Version.new(Bundler::VERSION) >= Gem::Version.new('2.0.0')
    spec.add_development_dependency "bundler", "~> 2.0"
  else
    spec.add_development_dependency "bundler", "~> 1.17"
  end
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
