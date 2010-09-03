##############################################################################
# File:: controller.rb
# Purpose:: Main Controller object for NormalizeXml utility
# 
# Author::    Jeff McAffee 09/03/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'ktcommon/ktpath'
require 'ktcommon/ktcmdline'

##############################################################################
# Everything is contained in Module	NormalizeXml
module NormalizeXml
	  
	class Controller

	attr_accessor 	:someFlag
	attr_accessor 	:model
	attr_reader 	:verbose
		
		def initialize()
			$LOG.debug "Controller::initialize"
			@cfg 			= Config.new.load
			@someFlag 		= false
			@model 			= Parser.new
			@model.verbose 	= false
		end
		  

		def verbose(arg)
			$LOG.debug "Controller::verbose( #{arg} )"
			puts "Verbose mode: #{arg.to_s}" if @verbose || arg
			@model.verbose = arg
		end
		  
	  
		def verbose=(arg)
			$LOG.debug "Controller::verbose=( #{arg} )"
			return verbose(arg)
		end
		  
	  
		def infile=(infile)
			@model.infile = infile
		end
		
		
		def outfile=(outfile)
			@model.outfile = outfile
		end
		
		
		def doSomethingWithSwitch(arg)
			$LOG.debug "Controller::doSomethingWithSwitch( #{arg} )"
		end
			  
		  
		def doSomethingWithCmdLineArg(arg)
			$LOG.debug "Controller::doSomethingWithCmdLineArg( #{arg} )"
			#raise ArgumentError.new("Unexpected argument: #{arg}")
			return true		# I want cmd line args
		end
			  
		  
		def noCmdLineArg()
			$LOG.debug "Controller::noCmdLineArg"
			raise ArgumentError.new("Argument expected.")
			return false			# No arg, no worky.
		end

		  
		def normalize()
			$LOG.debug "Controller::normalize"
			@model.normalize()
		end
		  
	  
	end # class Controller


end # module NormalizeXml
