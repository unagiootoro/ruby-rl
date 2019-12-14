
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rl/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby-rl"
  spec.version       = RL::VERSION
  spec.authors       = ["unagiootoro"]
  spec.email         = ["ootoro838861@outlook.jp"]

  spec.summary       = %q{Ruby reinforcement learning library.}
  spec.description   = %q{ruby-rl is a ruby reinforcement learning library.}
  spec.homepage      = "https://github.com/unagiootoro/ruby-rl.git"
  spec.license       = "MIT"

  spec.add_dependency "numo-narray"
  spec.add_dependency "ruby-dnn"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
