
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "blade/coin/version"

Gem::Specification.new do |spec|
  spec.name          = "blade_coin"
  spec.version       = Blade::Coin::VERSION
  spec.authors       = ["sai"]
  spec.email         = ["rubyer1993@gmail.com"]

  spec.summary       = "A cryptocurrency price monitoring tool"
  spec.description   = "A cryptocurrency price monitoring tool, you can run 'coin -h' for more help, or read the 'README.md'."
  spec.homepage      = "https://github.com/gith-u-b/blade_coin"
  spec.license       = "MIT"
  spec.add_dependency 'rainbow', "~> 2.1.0"
  spec.add_dependency 'terminal-table', '~> 3.0', '>= 3.0.2'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
