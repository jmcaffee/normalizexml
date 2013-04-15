require 'spec_helper'

describe NormalizeXMLTask do

  let(:task) { NormalizeXMLTask }
  let(:outdir) { Pathname.new 'tmp/spec/normalizexmltask' }
  let(:srcxml) { 'spec/data/test.xml' }

  before :each do
    out = Pathname.new outdir
    out.rmtree if out.exist? && out.directory?
  end

  let(:outfile) { outdir + 'test.nml.xml' }

  it ".normalize_file" do
    NormalizeXMLTask.normalize_file(srcxml, outdir)
    outfile.exist?.should be_true
  end

  context "normalized file" do

    it "starts with an XML declaration statement" do
      NormalizeXMLTask.normalize_file(srcxml, outdir)
      lines = file_to_array(outfile)
      lines[0].should include '<?xml version="1.0"?>'
    end

    it "contains GuidelineRoot opening and closeing tags" do
      NormalizeXMLTask.normalize_file(srcxml, outdir)
      lines = file_to_array(outfile)
      #puts "lines[1]: #{lines[1]}"
      #puts "line count: #{lines.size}"
      lines[1].should include "<GuidelineRoot>"
      lines[lines.size - 1].should include "</GuidelineRoot>"
    end

    it "normalizes all IDs to 0" do
      NormalizeXMLTask.normalize_file(srcxml, outdir)
      lines = file_to_array(outfile)
      lines.each do |line|
        if line.include?(' Id="')
          line.should include 'Id="0"'
        end
      end
    end
  end # context "normalized file"
end
