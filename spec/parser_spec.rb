require 'spec_helper'

describe NormalizeXml::Parser do

  let(:parser)    { NormalizeXml::Parser.new }
  let(:outdir)  { Pathname.new 'tmp/spec/normalizexml.parser' }
  let(:srcxml)  { 'spec/data/test.xml' }
  let(:srcxml2) { 'spec/data/test2.xml' }


  before :each do
    out = Pathname.new outdir
    out.rmtree if out.exist? && out.directory?
    # Parser does NOT create the output directory.
    out.mkpath
  end


  let(:outfile)  { outdir + 'test.nml.xml' }
  let(:outfile2) { outdir + 'test2.nml.xml' }


  context "#normalize" do
    
    it "generates an output file" do
      parser.infile = srcxml
      parser.outfile = outfile.to_s
      parser.normalize()

      expect(outfile.exist?).to eq true
    end



    let(:outputfile1) do
      parser.infile = srcxml
      parser.outfile = outfile.to_s
      parser.normalize()

      outfile
    end

    let(:outputfile2) do
      parser.infile = srcxml
      parser.outfile = outfile2.to_s
      parser.normalize()

      outfile2
    end

    context "outputfile" do
      
      it "starts with an XML declaration statement" do
        lines = file_to_array(outputfile1)
        lines[0].should include '<?xml version="1.0"?>'
      end

      it "contains GuidelineRoot opening and closing tags" do
        lines = file_to_array(outputfile1)
        lines[1].should include "<GuidelineRoot>"
        lines[lines.size - 1].should include "</GuidelineRoot>"
      end

      it "all IDs are normalized to 0" do
        lines = file_to_array(outputfile1)
        lines.each do |line|
          if line.include?(' Id="')
            line.should include 'Id="0"'
          end
        end
      end

      it "AssignTo lines are correctly pretty printed" do
        lines = file_to_array(outputfile2)
        lines.each do |line|
          if line.include?('<AssignTo>')
            line.should_not include '</AssignTo>'
          end
        end
      end


      context "Order attributes" do
        
        it "are stripped from Compute elements" do
          lines = file_to_array(outputfile2)
          lines.each do |line|
            if line.include?('<Compute')
              line.should_not include 'Order='
            end
          end
        end

        it "are stripped from AssignTo elements" do
          lines = file_to_array(outputfile2)
          lines.each do |line|
            if line.include?('<AssignTo')
              line.should_not include 'Order='
            end
          end
        end

        it "are stripped from Message elements" do
          lines = file_to_array(outputfile2)
          lines.each do |line|
            if line.include?('<Message')
              line.should_not include 'Order='
            end
          end
        end
      end # context "Order attributes"


      context "Id attributes" do
        
        it "are stripped from DPM elements" do
          lines = file_to_array(outputfile2)
          lines.each do |line|
            if line.include?('<DPM')
              line.should_not include 'Id='
            end
          end
        end

        it "are stripped from Ruleset elements" do
          lines = file_to_array(outputfile2)
          lines.each do |line|
            if line.include?('<Ruleset')
              line.should_not include 'Id='
            end
          end
        end

        it "are stripped from Rule elements" do
          lines = file_to_array(outputfile2)
          lines.each do |line|
            if line.include?('<Rule')
              line.should_not include 'Id='
            end
          end
        end
      end # context "Order attributes"
    end # context "outputfile"
  end # context "#normalize"
end
