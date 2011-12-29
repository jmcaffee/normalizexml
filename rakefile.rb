######################################################################################
# File:: rakefile
# Purpose:: Build tasks for NormalizeXml application
#
# Author::    Jeff McAffee 09/03/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
######################################################################################

require 'rubygems'
require 'psych'
gem 'rdoc', '>= 3.9.4'

require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'ostruct'
require 'rakeUtils'

# Setup common directory structure


PROJNAME        = "NormalizeXml"
BUILDDIR        = "build"
DISTDIR         = "./dist"
TESTDIR         = "test"
PKGDIR          = "pkg"

$:.unshift File.expand_path("../lib", __FILE__)
require "normalizexml/version"

PKG_VERSION	= NormalizeXml::VERSION
PKG_FILES 	= Dir["**/*"].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }

# Setup common clean and clobber targets

CLEAN.include("pkg")
CLOBBER.include("pkg")
CLEAN.include("#{BUILDDIR}/**/*.*")
CLOBBER.include("#{BUILDDIR}")
CLEAN.include("#{DISTDIR}/**/*.*")
CLOBBER.include("#{DISTDIR}/**/*.*")


directory BUILDDIR
directory DISTDIR
directory PKGDIR



#############################################################################
#### Imports
# Note: Rake loads imports only after the current rakefile has been completely loaded.

# Load local tasks.
imports = FileList['tasks/**/*.rake']
imports.each do |imp|
	puts "== Importing local task file: #{imp}" if $verbose
	import "#{imp}"
end



#############################################################################
#task :init => [BUILDDIR] do
task :init => [BUILDDIR, DISTDIR, PKGDIR] do

end


#############################################################################
RDoc::Task.new(:rdoc) do |rdoc|
    files = ['docs/**/*.rdoc', 'lib/**/*.rb', 'app/**/*.rb']
    rdoc.rdoc_files.add( files )
    rdoc.main = "docs/README.rdoc"           	# Page to start on
	#puts "PWD: #{FileUtils.pwd}"
    rdoc.title = "#{PROJNAME} Documentation"
    rdoc.rdoc_dir = 'doc'                   # rdoc output folder
    rdoc.options << '--line-numbers' << '--all'
end


#############################################################################
SPEC = Gem::Specification.new do |s|
	s.platform = Gem::Platform::RUBY
	s.summary = "Utility for normalizing .xml files"
	s.name = PROJNAME.downcase
	s.version = PKG_VERSION
	s.requirements << 'none'
	s.bindir = 'bin'
	s.require_path = 'lib'
	#s.autorequire = 'rake'
	s.files = PKG_FILES
	s.executables = "normalizexml"
	s.author = "Jeff McAffee"
	s.email = "gems@ktechdesign.com"
	s.homepage = "http://gems.ktechdesign.com"
	s.description = <<EOF
NormalizeXml is a utility for normalizing .xml files
EOF
end


#############################################################################
desc "Run all tests"
task :test => [:init] do
	unless File.directory?('test')
		$stderr.puts 'no test in this package'
		return
	end
	$stderr.puts 'Running tests...'
	begin
		require 'test/unit'
	rescue LoadError
		$stderr.puts 'test/unit cannot loaded.  You need Ruby 1.8 or later to invoke this task.'
	end
	
	$LOAD_PATH.unshift("./")
	$LOAD_PATH.unshift(TESTDIR)
	Dir[File.join(TESTDIR, "*.rb")].each {|file| require File.basename(file) }
	require 'minitest/autorun'
end


