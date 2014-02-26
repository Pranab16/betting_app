$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tt_betting/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tt_betting"
  s.version     = TtBetting::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of TtBetting."
  s.description = "TODO: Description of TtBetting."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.16"
  s.add_dependency "jquery-rails"

  s.add_dependency "rspec-rails"
  s.add_dependency "factory_girl_rails", "~> 4.0"
end
