========================================================================
= File: 	README.txt
= Purpose: 	Additions, modifications and notes for NormalizeXml.
=
= Generated:	09/03/2010
= Copyright: 	Copyright (c) 2010, kTech Systems LLC. All rights reserved.
= Website:   	http://ktechsystems.com
========================================================================

BUILDING THE PROJECT:

	Rake is used to build and install the project. By default, rake 
	will clean, and build docs for NormalizeXml source files.
	
	The available tasks are:
	
	
		rake clean         # Remove any temporary products.
		rake clobber       # Remove any generated file.
		rake clobber_rdoc  # Remove rdoc products
		rake rdoc          # Build the rdoc HTML Files
		rake rerdoc        # Force a rebuild of the RDOC files
		rake setup:clean   # Remove (uninstall) project from Ruby library
		rake setup:install # Install project into Ruby library
		rake setup:test    # Run all tests in test dir
