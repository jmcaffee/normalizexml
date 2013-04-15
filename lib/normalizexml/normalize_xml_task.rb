##############################################################################
# File::    normalize_xml_task.rb
# Purpose:: NormalizeXMLTask class definition
# 
# Author::    Jeff McAffee 04/15/2013
# Copyright:: Copyright (c) 2013, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'fileutils'

class NormalizeXMLTask
  
  def self.normalize_file(srcfile, output_dir, verbose = false)
    out_dir = Pathname.new output_dir
    out_file = Pathname.new(srcfile).basename.sub_ext('.nml.xml')
    out_path = out_dir + out_file
    out_dir.mkpath unless out_dir.exist?
    FileUtils.cp srcfile, out_path

    parser = NormalizeXml::Parser.new
    parser.infile = srcfile
    parser.outfile = out_path.to_s
    parser.verbose = verbose
    parser.normalize()
  end
end # class
