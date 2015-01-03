arcball
=======

cube.rb. This is a extended version of the cube program found on:
    
	github.com/larskanis/opengl

	the cube.rb file is located in the redbook folder.
	
The program has been modiefied with a ruby implementation of Ken Shoemake arcball controller.
See: Graphic Gems IV. Page 175. Academic Press LTD. 

Originally the cube is in a stationary position. Now it can be freely rotate around any axys.

The intention is to show the implementation of the arcball controller not to show OpenGL code. 

Advanced OpenGL programmers will immediately see the old style and heavy use of global variables.

A future program version will address this by using modern OpenGL and a better programming style.


Requirements:
-------------

opengl ruby library.
glu and glut libraries.
A Ruby installation.
The program was tested using Ruby 1.9.3 on Windows 7 and Debian 7


To check if the components are present in the system, type:

	$ gem list --local

Linux users may need administrator privileges.

The output will be something like this:

*** LOCAL GEMS ***
glu (8.2.1 x86-mingw32)
glut (8.2.1 x86-mingw32)
opengl (0.9.1 x86-mingw32)
etc ...

If this is about the same then you can execute the script.
If not, then you need to install them using 'gem' ( preferred method ) or by building the gems by yourself.

	$ gem install opengl <enter>
	$ gem install glu <enter>
	$ gem install glut <enter>

Installation:
-------------

(1) Clone the repository.
(2) Clone the rotorb repository - to have access to the rotation module.
(3) Change the path of the rotorb library inside cube.rb to the correct one.
(4) run using
	
	$ ruby .\cube.rb

License:
--------

The original Redbook code is licensed according to http://oss.sgi.com/projects/FreeB
The arcball controller implementation is Copyright(C) 2015 Jaime Ortiz.
See license.md file for licensing information.	
