##############################################################################
# File:: 	parser.rb
# Purpose:: Model object for NormalizeXml.
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
	  
	class Parser

	attr_accessor	:infile
	attr_accessor	:outfile
	attr_reader 	:verbose
		
		def initialize()
			$LOG.debug "Parser::initialize"
			
			@infile 	= nil
			@outfile	= nil
			@verbose	= false
			
		end
	  

		def verbose=(arg)
			$LOG.debug "Parser::verbose=( #{arg} )"
			@verbose = arg
		end
		  
	  
		def normalize()
			$LOG.debug "Parser::normalize"
			
			raise ArgumentError.new("infile not provided") unless !@infile.nil? && !@infile.empty?
			if( @outfile.nil? || @outfile.empty? )
				@outfile = @infile + ".nml"
			end
			
			# Open the file and parse each line...
			File.open(infile, "r") do |f|
				File.open(outfile, "w") do |fout|
					f.each do |lineIn|
						fout << parseLine(lineIn)
					end
				end
			end
			
			puts "Normalization complete."
			puts
			puts "Input file:  #{infile}"
			puts "Output file: #{outfile}"
			puts
		end
		  
	  
		def parseLine(ln)
			out = ln.gsub( /Order=\"(\d+)\"/, 'Order="0"')
			out = out.gsub( /Order= '(\d+)'/, 'Order="0"')
			out = out.gsub( /  Order=\"0\"/, ' Order="0"')
			out = out.gsub( /  Order=\"0\"/, ' Order="0"')
			out = out.gsub( /Order=\"0\">/, 'Order="0" >')
			out = out.gsub( /Id=\"(\d+)\"/, 'Id="0"')
			
		end
		
		
		def testTrue()
			$LOG.debug "Parser::testTrue"
			true
		end
		  
	  
		def testFalse()
			$LOG.debug "Parser::testFalse"
			false
		end
		  
	  
	end # class Parser



end # module NormalizeXml
