##############################################################################
# File:: normalizexml.rb
# Purpose:: Utility to ...
# 
# Author::    Jeff McAffee 09/03/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'normalizexml'
require 'user-choices'


class NormalizeXmlApp < UserChoices::Command
    include UserChoices
	include NormalizeXml
    
    def initialize()
        super
        @controller = Controller.new
    end
    
    
    def add_sources(builder)
        builder.add_source(CommandLineSource, :usage,
                            "Usage: #{$0} [options] CMDLINE_ARG",
                            "Application description",
                            "CMDLINE_ARG restrictions/description.")
    end # def add_sources
    
    
    def add_choices(builder)
        # Arguments
        #builder.add_choice(:cmdArg, :length=>1) { |command_line|   # Use length to REQUIRE args.
        builder.add_choice(:cmdArg) { |command_line|
            command_line.uses_arglist
        }
        
        # Switches
        builder.add_choice(:verbose, :type=>:boolean, :default=>false) { |command_line|
            command_line.uses_switch("-v", "--verbose",
                                    "Verbose output.")
        }
        
        builder.add_choice(:aswitch, :type=>:boolean, :default=>false) { |command_line|
            command_line.uses_switch("-a", "--aswitch",
                                    "Switch description.")
        }
        
        # Options
        builder.add_choice(:option, :type=>:string) { |command_line|
            command_line.uses_option("-o", "--option ARG",
                                    "Option description.")
        }
        
    end # def add_choices
    
    # This method is called automatically by UserChoices.
	# Use it to handle simple post processing of user choices.
	def postprocess_user_choices
		@user_choices[:infile] = @user_choices[:cmdArg][0]
		@user_choices[:outfile] = @user_choices[:cmdArg][1]
	end
	
	
    # Execute the NormalizeXml application.
    # This method is called automatically when 'normalizexml(.rb)' is executed from the command line.
    def execute
      $LOG.debug "NormalizeXmlApp::execute"

      if(@user_choices[:verbose])
        @controller.verbose(@user_choices[:verbose])
      end
      
      if(@user_choices[:aswitch])
        @controller.doSomethingWithSwitch(@user_choices[:aswitch])
        return
      end
      
      if(@user_choices[:cmdArg].empty?) # If no cmd line arg...
        return unless @controller.noCmdLineArg()
	  else
		return unless @controller.doSomethingWithCmdLineArg(@user_choices[:cmdArg])
	  end
      
		@controller.infile 	= @user_choices[:infile] unless @user_choices[:infile].nil? || @user_choices[:infile].empty?
		@controller.outfile = @user_choices[:outfile] unless @user_choices[:outfile].nil? || @user_choices[:outfile].empty?
      @controller.normalize()
    end # def execute
        
    
end # class NormalizeXmlApp


if $0 == __FILE__
	begin
		NormalizeXmlApp.new.execute
	rescue SystemExit
		
	rescue Exception => e
		puts "!!! ERROR:"
		puts "\t" + e.message
		puts
		puts "Try -h for help."
		puts
		exit if !$LOGGING
		puts "Exception type: #{e.class.to_s}"
		puts e.backtrace
		puts
	end	
end    
