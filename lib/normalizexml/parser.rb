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

require 'nokogiri'


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
				newfilename = File.basename(@infile, ".xml") + ".nml.xml"
				@outfile = File.join( File.absolute_path( File.dirname(@infile) ), newfilename )
			end
			
			puts "Normalizing file: #{@infile}"
			puts
			
			f = File.open(@infile, 'r')
			doc = Nokogiri::XML(f)
			f.close
			
			normalize_ids(doc)
			normalize_orders(doc)
			normalize_ppm_datatypes(doc)
			
			f = File.open(@outfile, 'w')
			doc.write_xml_to(f)
			f.close
			
			puts "Normalization of #{@infile} complete."
			puts "Output file: #{@outfile}"
			puts
		end
		  
	  
		###
		# Normalize Id attributes to 0
		# doc:: Nokogiri::XML document
		#
		def normalize_ids(doc)
			# Normalize all ruleset Ids
			rulesets = doc.xpath('//Ruleset')
			rulesets.each do |rs|
				rs['Id'] = "0"
			end
			
			# Normalize all rule Ids
			rules = doc.xpath('//Rule')
			rules.each do |r|
				r['Id'] = "0"
			end
			
		end
		
		
		###
		# Normalize Order attributes to 0
		# doc:: Nokogiri::XML document
		#
		def normalize_orders(doc)
			# Normalize all Compute Order attributes by removing them
			nodes = doc.xpath('//Compute')
			nodes.each do |n|
				n.remove_attribute('Order')
			end
			
			# Normalize all AssignTo Order attributes by removing them
			nodes = doc.xpath('//AssignTo')
			nodes.each do |n|
				n.remove_attribute('Order')
			end
			
		end
		
		
		###
		# Normalize PPM DataType attributes by removing them
		# doc:: Nokogiri::XML document
		#
		def normalize_ppm_datatypes(doc)
			# Normalize all PPM DataType attributes by removing them
			nodes = doc.xpath('//PPM')
			nodes.each do |n|
				n.remove_attribute('DataType')
			end
			
		end
		
		
		###
		# DEPRECATED - DO NOT USE
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
