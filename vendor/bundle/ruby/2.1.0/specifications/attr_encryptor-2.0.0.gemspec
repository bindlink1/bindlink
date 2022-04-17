# -*- encoding: utf-8 -*-
# stub: attr_encryptor 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "attr_encryptor"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Daniel Palacio"]
  s.date = "2013-07-17"
  s.description = "Generates attr_accessors that encrypt and decrypt attributes transparently"
  s.email = "danpal@gmail.com"
  s.homepage = "http://github.com/danpal/attr_encryptor"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.rdoc"]
  s.rubygems_version = "2.2.2"
  s.summary = "Encrypt and decrypt attributes"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<encryptor2>, [">= 1.0.0"])
      s.add_development_dependency(%q<activerecord>, [">= 2.0.0"])
      s.add_development_dependency(%q<datamapper>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<sequel>, [">= 0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<encryptor2>, [">= 1.0.0"])
      s.add_dependency(%q<activerecord>, [">= 2.0.0"])
      s.add_dependency(%q<datamapper>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<sequel>, [">= 0"])
      s.add_dependency(%q<dm-sqlite-adapter>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<encryptor2>, [">= 1.0.0"])
    s.add_dependency(%q<activerecord>, [">= 2.0.0"])
    s.add_dependency(%q<datamapper>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<sequel>, [">= 0"])
    s.add_dependency(%q<dm-sqlite-adapter>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
