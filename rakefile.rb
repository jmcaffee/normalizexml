######################################################################################
# File:: rakefile
# Purpose:: Build tasks for NormalizeXml application
#
# Author::    Jeff McAffee 09/03/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
######################################################################################

require 'bundler/gem_tasks'
require 'psych'
gem 'rdoc', '>= 3.9.4'

require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'rspec/core/rake_task'

# Setup common directory structure


PROJNAME        = "NormalizeXml"

# Setup common clean and clobber targets

CLEAN.include("pkg/**/*.*")
CLEAN.include("tmp/**/*.*")

CLOBBER.include("pkg")
CLOBBER.include("tmp")


#############################################################################
RDoc::Task.new(:rdoc) do |rdoc|
    files = ['docs/**/*.rdoc', 'lib/**/*.rb', 'app/**/*.rb']
    rdoc.rdoc_files.add( files )
    rdoc.main = "docs/README.rdoc"            # Page to start on
    rdoc.title = "#{PROJNAME} Documentation"
    rdoc.rdoc_dir = 'doc'                   # rdoc output folder
    rdoc.options << '--line-numbers' << '--all'
end

#############################################################################
desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  #t.rcov = true
end

