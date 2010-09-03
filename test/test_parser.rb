##############################################################################
# File:: test_parser.rb
# Purpose:: Test Parser class functionality
# 
# Author::    Jeff McAffee 09/03/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'test/unit'   #(1)
require 'flexmock/test_unit'
#require 'testhelper/filecomparer'
require 'logger'

require 'fileutils'

require 'normalizexml'

class  TestParser < Test::Unit::TestCase #(3)
    include FileUtils
    include FlexMock::TestCase
	include NormalizeXml

	
###
# setup - Set up test fixture
#
  def setup
    $LOG = Logger.new(STDERR)
    $LOG.level = Logger::DEBUG
    @baseDir = File.dirname(__FILE__)
    @dataDir = File.join(@baseDir, "data")
    
	@model = Parser.new
  end

  
###
# teardown - Clean up test fixture
#
  def teardown
	@model = nil
  end

  
###
# deletefile - delete the file if it exists
#
	def deletefile(filepath)
		if(File.exists?(filepath))
			FileUtils.rm(filepath)
			return true
		end
	
		return false	# No file to delete
	end
	
	
###
# test_parser_ctor - Test the constructor
#
  def test_parser_ctor
    target = Parser.new
    
    assert(nil != target)
  end

  
###
# test_parser_does_something
#
  def test_parser_does_something
    
  end
  

###
# test_parser_testtrue
#
  def test_parser_testtrue
    assert(true == @model.testTrue(), "TestTrue failed." )
  end
  

###
# test_parser_testfalse
#
  def test_parser_testfalse
    assert(false == @model.testFalse(), "TestFalse failed." )
  end
  

end # TestParser
