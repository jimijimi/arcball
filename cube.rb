# original file is cube.rb 
# taken from github.com/larskanis/opengl project
# this is the cube.rb example from the redbook folder.
# it has been modified and extended to handle the arcball controller.
# December 29, 2014
# the following script requires opengl, glu and glut
# to check if the components are present on the system, type:
#
#      $ gem list --local
#
# the output will be something like this:
#
# *** LOCAL GEMS ***
# glu (8.2.1 x86-mingw32)
# glut (8.2.1 x86-mingw32)
# opengl (0.9.1 x86-mingw32)
# etc ...
#
# if this is about the same then you can execute the script.
# if not, then you need to install them using gem ( preferred method )
#
#      $ gem install opengl <enter>
#      $ gem install glu <enter>
#      $ gem install glut <enter>
#
# you may need administrator privileges to execute gem 
# and under linux you may need to install ruby-dev package
#
# This script was tested in Debian 7 with ruby 1.9.3 
# and in Windows 7 with ruby 1.9.3



require 'opengl'
require 'glu'
require 'glut'
require '../rotorb/roto.rb'

include Gl, Glu, Glut

def myinit( )
	light_diffuse = [1.0, 0.0, 0.0, 1.0]
	light_position = [0.0, 0.0, 20.0, 0.0]
	two_sided = [ 1.0 ]
	white_light = [ 1.0, 1.0, 1.0, 1.0 ]
	mat_specular = [ 0.16, 0.16, 0.16, 1.0 ]
	mat_shininess = [ 50.0 ]
	#
	glShadeModel( GL_SMOOTH )
	glMaterialfv( GL_FRONT, GL_SPECULAR, mat_specular )
	glMaterialfv( GL_FRONT, GL_SHININESS, mat_shininess )
	glLight( GL_LIGHT0, GL_DIFFUSE, white_light )
	glLight( GL_LIGHT0, GL_POSITION, light_position )
	glLight( GL_LIGHT0, GL_SPECULAR, white_light )
	glLightModelfv( GL_LIGHT_MODEL_TWO_SIDE, two_sided )
	glEnable( GL_LIGHT0 )
	glEnable( GL_LIGHTING )
	glEnable( GL_DEPTH_TEST )
	glEnable( GL_COLOR_MATERIAL )
	glEnable( GL_RESCALE_NORMAL )
	glEnable( GL_BLEND )
	glColorMaterial( GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE )
	glMatrixMode( GL_PROJECTION )
	gluPerspective( 40.0, 1.0, 1.0, 10.0 )
	glMatrixMode( GL_MODELVIEW )
	gluLookAt( 0.0, 0.0, 6.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0 )
end

def drawBox
	glPushMatrix( )
	glMultMatrixf( $transformation ) 
	glColor3f( 1.0, 0.0, 0.0 )
	for i in ( 0..5 )
		glBegin( GL_QUADS )
		glNormal( *( $n[ i ] ) )
		glVertex( $v[ $faces[ i ][ 0 ] ] )
		glVertex( $v[ $faces[ i ][ 1 ] ] )
		glVertex( $v[ $faces[ i ][ 2 ] ] )
		glVertex( $v[ $faces[ i ][ 3 ] ] )
		glEnd( )
	end
	glPopMatrix( )
end

$n = [ [ 1.0, 0.0, 0.0 ], [ 0.0, -1.0, 0.0 ], [-1.0, 0.0,  0.0 ],
       [ 0.0, 1.0, 0.0 ], [ 0.0,  0.0, 1.0 ], [ 0.0, 0.0, -1.0 ] ]

$faces = [ [ 0, 1, 2, 3 ], [ 3, 2, 6, 7 ], [ 7, 6, 5, 4 ],
           [ 4, 5, 1, 0 ], [ 5, 6, 2, 1 ], [ 7, 4, 0, 3 ] ]


$v = [  [ -1, -1, 1 ], [ -1, -1, -1 ], [ -1, 1, -1 ], [ -1, 1, 1 ], 
	[  1, -1, 1 ], [  1, -1, -1 ], [  1, 1, -1 ], [  1, 1, 1 ] ]


$transformation = [ 1.0, 0.0, 0.0, 0.0,
                    0.0, 1.0, 0.0, 0.0,
	            0.0, 0.0, 1.0, 0.0,
		    0.0, 0.0, 0.0, 1.0 ]

$this_rotation = [ 1.0, 0.0, 0.0, 0.0,
                   0.0, 1.0, 0.0, 0.0,
		   0.0, 0.0, 1.0, 0.0,
		   0.0, 0.0, 0.0, 1.0 ]			  

$last_rotation = [ 1.0, 0.0, 0.0, 0.0,
                   0.0, 1.0, 0.0, 0.0,
		   0.0, 0.0, 1.0, 0.0,
		   0.0, 0.0, 0.0, 1.0 ]

$left_button_down = 0
$set_initial_coordinate = 1
$screen_center_x
$screen_center_y
$sphere_radius
$v0 = []
$v1 = []
$qdrag = []
			
display = Proc.new do
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	drawBox
	glutSwapBuffers
end

keyboard = Proc.new do |key, x, y|
	case (key)
		when ?\e
		exit(0);
	end
end

mouse = Proc.new do | button, state, x, y |
	if button == GLUT_LEFT_BUTTON
		$left_button_down = 1
	end
		
	if state == GLUT_UP
		$left_button_down = 0
		$set_initial_coordinate = 1
	end
end

# arcball controller inside mouse function callback

mouse_motion = Proc.new do | x, y |
	if $left_button_down == 1
		window_width = glutGet( GLUT_WINDOW_WIDTH )
		window_height = glutGet( GLUT_WINDOW_HEIGHT )
		$screen_center_x = window_width / 2.0
		$screen_center_y = window_height / 2.0
		$sphere_radius = Roto.vectorMagnitude( [ $screen_center_x, $screen_center_y, 0 ] ) 
		if $set_initial_coordinate == 1
			$last_rotation = $transformation
			$v0 = [ ( x - $screen_center_x ) / $sphere_radius, ( y - $screen_center_y ) / $sphere_radius, 0 ]
			v0_magnitude = Roto.vectorMagnitude( $v0 )
			$v0[ 2 ] = ( 1 - v0_magnitude ** 2 ) ** 0.5
			$set_initial_coordinate = 0
		elsif  x >= 0 && x <= window_width && y >= 0 && y <= window_height
			$v1 = [ ( x - $screen_center_x ) / $sphere_radius, ( y - $screen_center_y ) / $sphere_radius, 0 ]
			v1_magnitude = Roto.vectorMagnitude( $v1 )
			$v1[ 2 ] = ( 1 - v1_magnitude ** 2 ) ** 0.5
			quat_vector_part = Roto.vectorCrossProduct( $v0, $v1 )
			quat_real_part = Roto.vectorDotProduct( $v0, $v1 )
			$qdrag = [ quat_real_part, quat_vector_part[ 0 ], -quat_vector_part[ 1 ], quat_vector_part[ 2 ] ]
			$this_rotation = Roto.quaternionToMatrix( $qdrag )
			$transformation = Roto.matrix4x4_Multiplication( $last_rotation, $this_rotation )
			glutPostRedisplay( )
		end
	end
end

glutInit
glutInitDisplayMode( GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH )
glutInitWindowSize( 500, 500 )
glutInitWindowPosition( 100, 100 )
glutCreateWindow( "red 3D lighted cube with arcball controller" )
glutDisplayFunc( display )
glutKeyboardFunc( keyboard )
glutMouseFunc( mouse )
glutMotionFunc( mouse_motion )
myinit( )
glutMainLoop( )
