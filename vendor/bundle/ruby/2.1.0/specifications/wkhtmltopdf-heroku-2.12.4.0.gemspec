# -*- encoding: utf-8 -*-
# stub: wkhtmltopdf-heroku 2.12.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "wkhtmltopdf-heroku"
  s.version = "2.12.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brad Phelan"]
  s.date = "2017-04-04"
  s.description = "This gem provides a wkhtmltopdf binary and configures wisepdf, wicked_pdf, and pdfkit for ruby based applications running in Heroku's Cedar-14 stack"
  s.email = "bradphelan@xtargets.com"
  s.executables = ["wkhtmltopdf-linux-amd64"]
  s.extra_rdoc_files = ["LICENSE.txt", "README.mdown"]
  s.files = ["LICENSE.txt", "README.mdown", "bin/wkhtmltopdf-linux-amd64"]
  s.homepage = "http://github.com/rposborne/wkhtmltopdf-heroku"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.2.2"
  s.summary = "provides wkhtmltopdf binaries for heroku cedar-14 stack"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version
end
