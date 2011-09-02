##############################################################################
# Everything is contained in Module NormalizeXml
#
module NormalizeXml

  VERSION = "0.0.1" unless constants.include?("VERSION")
	APPNAME = "NormalizeXml" unless constants.include?("APPNAME")
	COPYRIGHT = "Copyright (c) 2011, kTech Systems LLC. All rights reserved." unless constants.include?("COPYRIGHT")


	def self.logo()
		return	[	"#{NormalizeXml::APPNAME} v#{NormalizeXml::VERSION}",
							"#{NormalizeXml::COPYRIGHT}",
							""
						].join("\n")
	end


end # module NormalizeXml
