##############################################################################
# File:: normalizexml.rb
# Purpose:: Include file for NormalizeXml library
# 
# Author::    Jeff McAffee 09/03/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'find'
require 'logger'
require 'win32ole'


if(!$LOG)
  $LOG = Logger.new(STDERR)
  $LOG.level = Logger::ERROR
end

if ENV["DEBUG"] == '1'
  puts "LOGGING: ON due to DEBUG=1"
  $LOG.level = Logger::DEBUG
end

$LOGGING = false
# Uncomment line below to force logging:
#$LOGGING = true   # TODO: Change this flag to false when releasing production build.

require "#{File.join( File.dirname(__FILE__), 'normalizexml','version')}"
require "#{File.join( File.dirname(__FILE__), 'normalizexml','config')}"

logcfg = NormalizeXml::Config.new.load
if(logcfg.key?(:logging) && (true == logcfg[:logging]) )
  $LOGGING = true 
end

if($LOGGING)
  # Create a new log file each time:
  file = File.open('normalizexml.log', File::WRONLY | File::APPEND | File::CREAT | File::TRUNC)
  $LOG = Logger.new(file)
  $LOG.level = Logger::DEBUG
  #$LOG.level = Logger::INFO
else
  if(File.exists?('normalizexml.log'))
FileUtils.rm('normalizexml.log')
end
end
$LOG.info "**********************************************************************"
$LOG.info "Logging started for NormalizeXml library."
$LOG.info "**********************************************************************"


class_files = File.join( File.dirname(__FILE__), 'normalizexml', '*.rb')
$: << File.join( File.dirname(__FILE__), 'normalizexml')  # Add directory to the include file array.
Dir.glob(class_files) do | class_file |
    require class_file[/\w+\.rb$/]
end

