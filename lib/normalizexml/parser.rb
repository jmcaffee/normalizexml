##############################################################################
# File::  parser.rb
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
# Everything is contained in Module NormalizeXml
module NormalizeXml

  class Parser

  attr_accessor :infile
  attr_accessor :outfile
  attr_reader   :verbose

    def initialize()
      $LOG.debug "Parser::initialize"

      @infile   = nil
      @outfile  = nil
      @verbose  = false

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

      puts "Normalizing file: #{@infile}\n\n" if @verbose

      # Find instances of '> <' and replace them with '><'.
      strip_spaces(@infile, @outfile)

      f = File.open(@outfile, 'r')
      doc = Nokogiri::XML(f)
      f.close

      remove_id_attributes(doc)
      remove_order_attributes(doc)
      normalize_ppm_datatypes(doc)
      sort_derivedparameters(doc)
      sort_conditions(doc)
      update_condition_attributes(doc)

      f = File.open(@outfile, 'w')
      doc.write_xml_to(f)
      f.close

      if @verbose
        puts "Normalization of #{@infile} complete."
        puts "Output file: #{@outfile}"
        puts
      end
    end


    def strip_spaces(infile, outfile)
      buffer = IO.read(infile)
      buffer.gsub!('> <', '><')
      File.open(outfile, 'w') {|f| f.write buffer }
    end


    ###
    # Remove Id attributes
    # doc:: Nokogiri::XML document
    #
    def remove_id_attributes(doc)
      # Normalize all ruleset Ids
      rulesets = doc.xpath('//Ruleset')
      rulesets.each do |rs|
        rs.remove_attribute('Id')
      end

      # Normalize all rule Ids
      rules = doc.xpath('//Rule')
      rules.each do |r|
        r.remove_attribute('Id')
      end

      # Remove all DPM Ids
      rules = doc.xpath('//DPM')
      rules.each do |r|
        r.remove_attribute('Id')
      end

    end


    ###
    # Add Condition attributes
    # doc:: Nokogiri::XML document
    #
    def update_condition_attributes(doc)
      # Add SystemName attribute to condition elements without a Name element.
      conddefs = {}

      # Get all conditions.
      conditions = doc.xpath('//Message[@Type="Condition"]')

      # Make a crossref hash of the IDs and Names.
      conditions.each do |c|
        conddefs[c['Id']] = c['Name'] if c.has_attribute?('Name')
      end

      # Add SystemName attribute if Name is missing (condition references)
      conditions.each do |c|
        c['SystemName'] = conddefs[c['Id']] if !c.has_attribute?('Name')
      end

      # Remove all condition IDs
      conditions.each do |c|
        c.remove_attribute('Id')
      end
    end


    ###
    # Remove Order attributes
    # doc:: Nokogiri::XML document
    #
    def remove_order_attributes(doc)
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

      # Normalize all Message Order attributes by removing them
      nodes = doc.xpath('//Message')
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
    # Sort all DERIVEDPARAMETERS children by sorting them
    # alphabetically by Name.
    # doc:: Nokogiri::XML document
    #
    # To get this to work, the following flow was used:
    #   1. Create a sorted array of all child nodes.
    #   2. Create a new node and add each node from the array (giving us sorted order).
    #   3. Delete (unlink) each of the sorted child nodes from the original node.
    #   4. Add the new node as a sibling to the originial node.
    #   5. Delete (unlink) the original node
    #   6. Rename the new node to the same name as the deleted node.
    def sort_derivedparameters(doc)
      node = doc.xpath('//DERIVEDPARAMETERS')
      
      sorted = node.children.sort_by do |n1|
        n1['Name']
      end
      node.children.each { |n| n.unlink }

      newnode = doc.create_element "SortedDPMs"
      sorted.each do |n|
        newnode << n;
      end

      doc.at('DERIVEDPARAMETERS').add_next_sibling( newnode )
      node.unlink
      newnode.name = 'DERIVEDPARAMETERS'
    end


    ###
    # Sort all Conditions children by sorting them
    # alphabetically by Name.
    # doc:: Nokogiri::XML document
    #
    # To get this to work, the following flow was used:
    #   1. Create a sorted array of all child nodes.
    #   2. Create a new node and add each node from the array (giving us sorted order).
    #   3. Delete (unlink) each of the sorted child nodes from the original node.
    #   4. Add the new node as a sibling to the originial node.
    #   5. Delete (unlink) the original node
    #   6. Rename the new node to the same name as the deleted node.
    def sort_conditions(doc)
      node = doc.xpath('//Conditions')
      # Return if this guideline does not contain the conditions element.
      return if node.empty?

      sorted = node.children.sort_by do |n1|
        n1['Name']
      end
      node.children.each { |n| n.unlink }

      newnode = doc.create_element "SortedConditions"
      sorted.each do |n|
        newnode << n;
      end

      doc.at('Conditions').add_next_sibling( newnode )
      node.unlink
      newnode.name = 'Conditions'
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
