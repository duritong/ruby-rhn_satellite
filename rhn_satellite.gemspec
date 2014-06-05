# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: rhn_satellite 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rhn_satellite"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["duritong"]
  s.date = "2014-06-03"
  s.description = "It provides an easy way to interact with a RedHat Satellite API."
  s.email = "peter.meier@immerda.ch"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/rhn_satellite.rb",
    "lib/rhn_satellite/activation_key.rb",
    "lib/rhn_satellite/api.rb",
    "lib/rhn_satellite/channel.rb",
    "lib/rhn_satellite/channel_access.rb",
    "lib/rhn_satellite/channel_software.rb",
    "lib/rhn_satellite/common/collection.rb",
    "lib/rhn_satellite/common/debug.rb",
    "lib/rhn_satellite/common/misc.rb",
    "lib/rhn_satellite/connection/base.rb",
    "lib/rhn_satellite/connection/handler.rb",
    "lib/rhn_satellite/packages.rb",
    "lib/rhn_satellite/schedule.rb",
    "lib/rhn_satellite/system.rb",
    "lib/rhn_satellite/systemgroup.rb",
    "rhn_satellite.gemspec",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/unit/rhn_satellite/activation_key_spec.rb",
    "spec/unit/rhn_satellite/api_spec.rb",
    "spec/unit/rhn_satellite/channel_access_spec.rb",
    "spec/unit/rhn_satellite/channel_software_spec.rb",
    "spec/unit/rhn_satellite/channel_spec.rb",
    "spec/unit/rhn_satellite/common/debug_spec.rb",
    "spec/unit/rhn_satellite/common/misc_spec.rb",
    "spec/unit/rhn_satellite/connection/base_spec.rb",
    "spec/unit/rhn_satellite/connection/handler_spec.rb",
    "spec/unit/rhn_satellite/packages_spec.rb",
    "spec/unit/rhn_satellite/schedule_spec.rb",
    "spec/unit/rhn_satellite/system_spec.rb",
    "spec/unit/rhn_satellite/systemgroup_spec.rb"
  ]
  s.homepage = "http://github.com/duritong/ruby-rhn_satellite"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.1"
  s.summary = "RhnSatellite is a ruby api to the RedHat Satellite"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.8"])
      s.add_development_dependency(%q<mocha>, ["~> 0.10.0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.8"])
      s.add_dependency(%q<mocha>, ["~> 0.10.0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.5.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.8"])
    s.add_dependency(%q<mocha>, ["~> 0.10.0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

