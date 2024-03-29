require_relative 'lib/ads_pub_sub/version'

Gem::Specification.new do |spec|
  spec.name          = "ads_pub_sub"
  spec.version       = AdsPubSub::VERSION
  spec.authors       = ["javierg"]
  spec.email         = ["javierg@amcoonline.net"]

  spec.summary       = %q{Small private gem for interface with pubsub systems for Amco}

  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.2")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.add_dependency "google-cloud-pubsub", "~> 2.9"
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
