# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "middleman-votb_publisher"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["M. Auayan"]
  s.email       = ["daev@bletchley.co"]
  # s.homepage    = "http://example.com"
  s.summary     = %q{Publish articles for CORS consumption.}
  s.description = %q{Publish articles for CORS conspumption from a specific domain and path}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 3.3.6"])
  
  # Additional dependencies
  # s.add_runtime_dependency("gem-name", "gem-version")
end
