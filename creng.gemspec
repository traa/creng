# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "creng/version"

Gem::Specification.new do |s|
  s.name        = "creng"
  s.version     = Creng::VERSION
  s.authors     = ["Andrew Stepikov"]
  s.email       = ["stagedown@gmail.com"]
  s.homepage    = "http://markeeper.ru"
  s.summary     = %q{Create chrome extension with ease}
  s.description = %q{Using this gem, you can create chrome extension skeleton with no troubles. The aim of project to make development of chrome extensions more simple, giving to user time-tested tools and development patterns.}

  s.rubyforge_project = "creng"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.executables = ["creng"]
  s.require_paths = ["lib"]

  s.add_dependency "rdf", "~> 0.3.10"

  s.post_install_message = "This gem allows you to easily create, manage and develop your own chrome extension. For detailed information about usage type 'creng help'"

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
