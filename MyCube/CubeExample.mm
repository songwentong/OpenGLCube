

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "EAGLView.h"
#import "Utils.h"

#pragma mark -
#pragma mark Variables
//**********************************************************************************************************
//
//  Variables
//
//**********************************************************************************************************

static float rotationX = 0;
static float rotationY = 0;
float _speedX;
float _speedY;
float _scale;
float _positionX;
float _positionY;

/*
float _rotationX;
float _rotationY;

*/

// Sizes. Width and Height.
float		_surfaceWidth;
float		_surfaceHeight;

// Frame and Render buffer names/ids.
GLuint		_framebuffer;
GLuint		_colorbuffer;
GLuint		_depthbuffer;

// Program Object name/id.
GLuint		_program;

// Informations about the mesh.
int			_stride;
int			_structureCount;
int			_indicesCount;

// Buffer Objects names/ids.
GLuint		_boStructure;
GLuint		_boIndices;

// Texture Object name/id.
GLuint		_texture;

// Attributes and Uniforms locations.
GLuint		_uniforms[2];
GLuint		_attributes[2];

#pragma mark -
#pragma mark New Methods
//**********************************************************************************************************
//
//  New methods
//
//**********************************************************************************************************

/*!
 *	@function		newTexture
 *	
 *	@abstract		Returns a new Texture Object name/id.
 *
 *	@discussion		This function creates a new Texture Object based on width, height and data.
 *
 *	@param			width
 *					The width in pixels of the texture.
 *
 *	@param			height
 *					The height in pixels of the texture.
 *
 *	@param			data
 *					The data to construct the texture (array of pixels).
 */
GLuint newTexture(GLsizei width, GLsizei height, const GLvoid *data)
{
	GLuint newTexture;
	
	// Generates a new texture name/id.
	glGenTextures(1, &newTexture);
	
	// Binds the new name/id to really create the texture and hold it to set its properties.
	glBindTexture(GL_TEXTURE_2D, newTexture);
	
	// Uploads the pixel data to the bound texture.
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	// Defines the Minification and Magnification filters to the bound texture.
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// Generates a full MipMap chain to the current bound texture.
	glGenerateMipmap(GL_TEXTURE_2D);
	
	return newTexture;
}

/*!
 *	@function		newBufferObject
 *	
 *	@abstract		Returns a new Buffer Object name/id.
 *
 *	@discussion		This function creates a new Buffer Object of a specific type based on size and data.
 *
 *	@param			type
 *					The Buffer Object type, this parameter can be
 *					GL_ARRAY_BUFFER or GL_ELEMENT_ARRAY_BUFFER.
 *
 *	@param			size
 *					The size of the buffer in basic machine units (bytes).
 *
 *	@param			data
 *					The data to be stored.
 */
GLuint newBufferObject(GLenum type, GLsizeiptr size, const GLvoid *data)
{
	GLuint buffer;
	
	// Generates the vertex buffer object (VBO)
	glGenBuffers(1, &buffer);
	
	// Bind the VBO so we can fill it with data
	glBindBuffer(type, buffer);
	glBufferData(type, size, data, GL_STATIC_DRAW);
	
	return buffer;
}

/*!
 *	@function		newProgram
 *	
 *	@abstract		Returns a new Program Object name/id.
 *
 *	@discussion		This function creates a new Program based on already compiled shaders
 *					pair (VSH and FSH).
 *
 *	@param			vertexShader
 *					The Vertex Shader's name/id.
 *
 *	@param			fragmentShader
 *					The Fragment Shader's name/id.
 */
GLuint newProgram(GLuint vertexShader, GLuint fragmentShader)
{
	GLuint name;
	
	// Creates the program name/index.
	name = glCreateProgram();
	
	// Will attach the fragment and vertex shaders to the program object.
	glAttachShader(name, vertexShader);
	glAttachShader(name, fragmentShader);
	
	// Will link the program into OpenGL core.
	glLinkProgram(name);
	
#if defined(DEBUG)
	
	GLint logLength;
	
	// Instead use GL_INFO_LOG_LENGTH we could use COMPILE_STATUS.
	// I prefer to take the info log length, because it'll be 0 if the
	// shader was successful compiled. If we use COMPILE_STATUS
	// we will need to take info log length in case of a fail anyway.
	glGetProgramiv(name, GL_INFO_LOG_LENGTH, &logLength);
	
	if (logLength > 0)
	{
		// Allocates the necessary memory to retrieve the message.
		GLchar *log = (GLchar *)malloc(logLength);
		
		// Get the info log message.
		glGetProgramInfoLog(name, logLength, &logLength, log);
		
		// Shows the message in console.
		printf("Error in Program Creation:\n%s\n",log);
		
		// Frees the allocated memory.
		free(log);
	}
#endif
	
	return name;
}

/*!
 *	@function		newShader
 *	
 *	@abstract		Returns a new Shader Object name/id.
 *
 *	@discussion		This function creates a new Shader of a specific type based on source code.
 *
 *	@param			type
 *					The Shader type, this parameter can be
 *					GL_VERTEX_SHADER or GL_FRAGMENT_SHADER.
 *
 *	@param			source
 *					An array of strings containing the source. As this function only create one
 *					shader at once, this array should be an array with one element only.
 */
GLuint newShader(GLenum type, const char **source)
{
	GLuint name;
	
	// Creates a Shader Object and returns its name/id.
	name = glCreateShader(type);
	
	// Uploads the source to the Shader Object.
	glShaderSource(name, 1, source, NULL);
	
	// Compiles the Shader Object.
	glCompileShader(name);
	
	// If are running in debug mode, query for info log.
	// DEBUG is a pre-processing Macro defined to the compiler.
	// Some languages could not has a similar to it.
#if defined(DEBUG)
	
	GLint logLength;
	
	// Instead use GL_INFO_LOG_LENGTH we could use COMPILE_STATUS.
	// I prefer to take the info log length, because it'll be 0 if the
	// shader was successful compiled. If we use COMPILE_STATUS
	// we will need to take info log length in case of a fail anyway.
	glGetShaderiv(name, GL_INFO_LOG_LENGTH, &logLength);
	
	if (logLength > 0)
	{
		// Allocates the necessary memory to retrieve the message.
		GLchar *log = (GLchar *)malloc(logLength);
		
		// Get the info log message.
		glGetShaderInfoLog(name, logLength, &logLength, log);
		
		// Shows the message in console.
		printf("Error in Shader Creation:\n%s\n",log);
		
		// Frees the allocated memory.
		free(log);
	}
#endif
	
	return name;
}

#pragma mark -
#pragma mark Methods of Creation
//**********************************************************************************************************
//
//  Methods of Creation
//
//**********************************************************************************************************

/*!
 *	@function		createTexture
 *	
 *	@abstract		Creates a Texture Object.
 *
 *	@discussion		This function takes all necessary informations from the parsed image.
 */
void createTexture(void)
{
	// Creates the texture.
	_texture = newTexture([[EAGLView image] width], [[EAGLView image] height], [[EAGLView image] data]);
}

/*!
 *	@function		createBufferObjects
 *	
 *	@abstract		Creates the mesh and its Buffer Objects.
 *
 *	@discussion		This function contains an array of structures (vertex + texture coordinates)
 *					and an array of indices.
 *					This array of structure creates a cube. Cubes are formed by 8 vertices.
 *					To optimize the UV Map, this cube uses only 12 texture coordinates.
 *					As illustrated below:
 *
 *					<pre>
 *					 ___________________________________
 *					|+-----------+-----------+          |
 *					||1          |2          |3         |
 *					||           |           |          |
 *					||   Left    |   Front   |-> UV Map |
 *					||           |           |          |
 *					||           |           |          |
 *					|+-----------+-----------+          |-> Image of 256 x 256
 *					||4          |5          |6         |
 *					||           |           |          |
 *					||    Top    |   Right   |          |
 *					||           |           |          |
 *					||           |           |          |
 *					|+-----------+-----------+-> A Tex. |
 *					||7          |8          |9  Coord. |
 *					||           |           |          |
 *					||  Bottom   |   Back    |          |
 *					||           |           |          |
 *					||10         |11         |12        |
 *					|+-----------+-----------+          |  
 *					|___________________________________|
 *					</pre>
 *
 *					So the combination of 8 unique vertices with 12 texture coordinates produces
 *					20 unique structures.
 */
void createBufferObjects(void)
{
	// Cube structure. 100 floats.
	_structureCount = 100;
	GLfloat cubeStructure[] =
	{
		0.50, -0.50, -0.50, -0.00, 0.00,
		0.50, -0.50, 0.50, 0.33, 0.00,
		-0.50, -0.50, 0.50, 0.33, 0.33,
		-0.50, -0.50, -0.50, -0.00, 0.33,
		0.50, 0.50, -0.50, 0.67, 0.33,
		0.50, -0.50, -0.50, 0.33, 0.33,
		-0.50, -0.50, -0.50, 0.33, 0.00,
		-0.50, 0.50, -0.50, 0.67, 0.00,
		0.50, 0.50, 0.50, 0.67, 0.67,
		0.50, -0.50, 0.50, 0.33, 0.67,
		-0.50, 0.50, 0.50, 0.67, 1.00,
		-0.50, -0.50, 0.50, 0.33, 1.00,
		-0.50, 0.50, -0.50, 0.33, 1.00,
		-0.50, -0.50, -0.50, -0.00, 1.00,
		-0.50, -0.50, 0.50, -0.00, 0.67,
		-0.50, 0.50, 0.50, 0.33, 0.67,
		-0.50, 0.50, 0.50, -0.00, 0.67,
		0.50, 0.50, 0.50, -0.00, 0.33,
		0.50, 0.50, -0.50, 0.33, 0.33,
		-0.50, 0.50, -0.50, 0.33, 0.67,
	};
	
	// Cube indices. 36 floats.
	_indicesCount = 36;
	GLushort cubeIndices[] =
	{
		0, 1, 2,
		2, 3, 0,
		4, 5, 6,
		6, 7, 4,
		8, 9, 5,
		5, 4, 8,
		10, 11, 9,
		9, 8, 10,
		12, 13, 14,
		14, 15, 12,
		16, 17, 18,
		18, 19, 16,
	};
	
	// Define the stride to the "cubeStructure".
	_stride = 5 * sizeof(GLfloat);
	
	// Creates the ABO and IBO.
	_boStructure = newBufferObject(GL_ARRAY_BUFFER, _structureCount * sizeof(GLfloat), cubeStructure);
	_boIndices = newBufferObject(GL_ELEMENT_ARRAY_BUFFER, _indicesCount * sizeof(GLushort), cubeIndices);
}

/*!
 *	@function		createProgramAndShaders
 *	
 *	@abstract		Creates the Program Object and the Shader Objects.
 *
 *	@discussion		This function contains a literal string to the VSH and FSH.
 */
void createProgramAndShaders(void)
{
	const char *vshSource = "\
	precision mediump float;\
	precision lowp int;\
	\
	uniform mat4			u_mvpMatrix;\
	\
	attribute highp vec4	a_vertex;\
	attribute vec2			a_texCoord;\
	\
	varying vec2			v_texCoord;\
	\
	void main(void)\
	{\
		v_texCoord = a_texCoord;\
	\
		gl_Position = u_mvpMatrix * a_vertex;\
	}";
	
	const char *fshSource = "\
	precision mediump float;\
	precision lowp int;\
	\
	uniform sampler2D		u_map;\
	\
	varying vec2			v_texCoord;\
	\
	void main (void)\
	{\
        gl_FragColor = texture2D(u_map, v_texCoord);\
	}";
	
	GLuint vsh, fsh;
	
	// Creates the pair of Shaders.
	vsh = newShader(GL_VERTEX_SHADER, &vshSource);
	fsh = newShader(GL_FRAGMENT_SHADER, &fshSource);
	
	// Creates the Program Object.
	_program = newProgram(vsh, fsh);
	
	// Clears the shaders objects.
	// In this case we can delete the shaders because we'll not use they anymore,
	// the OpenGL stores a copy of them into the program object.
	glDeleteShader(vsh);
	glDeleteShader(fsh);
	
	// Gets the uniforms locations.
	_uniforms[0] = glGetUniformLocation(_program, "u_mvpMatrix");
	_uniforms[1] = glGetUniformLocation(_program, "u_map");
	
	// Gets the attributes locations.
	_attributes[0] = glGetAttribLocation(_program, "a_vertex");
	_attributes[1] = glGetAttribLocation(_program, "a_texCoord");
	
	// As we'll use only those pair of shaders, let's enable the dynamic attributes to they once.
	glEnableVertexAttribArray(_attributes[0]);
	glEnableVertexAttribArray(_attributes[1]);
}

/*!
 *	@function		createFrameAndRenderbuffers
 *	
 *	@abstract		Creates the frame buffer and the render buffers.
 *
 *	@discussion		This application will use a color and a depth render buffers.
 */
void createFrameAndRenderbuffers(void)
{
	// Creates the Frame buffer.
	glGenFramebuffers(1, &_framebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);

	// Creates the render buffer.
	// Here the EAGL compels us to change the default OpenGL behavior.
	// Instead to use glRenderbufferStorage(GL_RENDERBUFFER, GL_RGB565, _surfaceWidth, _surfaceHeight);
	// We need to use renderbufferStorage: defined here in the [EAGLView propertiesToCurrentColorbuffer];
	glGenRenderbuffers(1, &_colorbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _colorbuffer);
	[EAGLView propertiesToCurrentColorbuffer];
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorbuffer);
	
	// Creates the Depth render buffer.
	// Try to don't enable the GL_DEPTH_TEST to see what happens.
	// The render will not respect the Z Depth informations of the 3D objects.
	glGenRenderbuffers(1, &_depthbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _depthbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _surfaceWidth, _surfaceHeight);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthbuffer);
	glEnable(GL_DEPTH_TEST);
	
	// Checks for the errors in the DEBUG mode. Is very commom make some mistakes at the Frame and
	// Render buffer creation, so is important you make this check, at least while you are learning.
#if defined(DEBUG)
	switch (glCheckFramebufferStatus(GL_FRAMEBUFFER))
	{
		case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
			printf("Error creating FrameBuffer: Incomplete Attachment.\n");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
			printf("Error creating FrameBuffer: Missing Attachment.\n");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
			printf("Error creating FrameBuffer: Incomplete Dimensions.\n");
			break;
		case GL_FRAMEBUFFER_UNSUPPORTED:
			printf("Error creating FrameBuffer: Unsupported Buffers.\n");
			break;
	}
#endif
}

#pragma mark -
#pragma mark Render Methods
//**********************************************************************************************************
//
//  Render Methods
//
//**********************************************************************************************************

/*!
 *	@function		preRender
 *	
 *	@abstract		First step in the render process.
 *
 *	@discussion		Clears any remaneing vestige of the last rendered frame.
 */
void preRender(void)
{
	// Clears the color and depth render buffer.
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// Clears an amount of color in the color render buffer.
	glClearColor(0.2, 0.3, 0.5, 1.0);
}

/*!
 *	@function		drawScene
 *	
 *	@abstract		Middle step in the render process.
 *
 *	@discussion		This function draws the 3D objects in the OpenGL scene.
 */
void drawScene(void)
{
	//***********************************************
	//  Calculate the ModelViewProjection Matrix
	//***********************************************

//	static float rotation = 0;
    
//	rotation += 2;
    rotationX += _speedX;
    rotationY += _speedY;
	
	mat4 matRotateY;
	mat4 matRotateX;
	mat4 matModelView;
	mat4 matProjection;
	mat4 matModelViewProjection;
    
    
    mat4 matScale;

	
	// Creates matrix rotations to X and Y.
	matrixRotateX(- rotationX * .25, matRotateX);
	matrixRotateY(rotationY, matRotateY);
	
	// This order produces a Local rotation (premultiply).
	// To see a Global rotation just the the order of this multiplication.
	// Like this matrixMultiply(matRotateX, matRotateY, matModelView);
	matrixMultiply(matRotateY, matRotateX, matModelView);
    
    matrixScale(_scale, _scale, _scale, matScale);
    
    matrixMultiply(matScale, matModelView, matModelView);
	
	// Translates the matrix, by going back in the Z axis.
	// Translation can be done without new matrices, look in Utils.h file.
//	matrixTranslate(0, 0, -3.0, matModelView);
    matrixTranslate(_positionX, _positionY, -3.0, matModelView);

	
	// Creates Projection Matrix.
	matrixPerspective(45.0, 0.1, 100.0, _surfaceWidth / _surfaceHeight, matProjection);
	
	// Multiplies the Projection by the ModelView to create the ModelViewProjection matrix.
	matrixMultiply(matProjection, matModelView, matModelViewProjection);
	
	//***********************************************
	//  OpenGL Drawing Operations
	//***********************************************
	
	// Starts to use a specific program. In this application this doesn't change anything.
	// But if you have many drawings in your application, then you'll need to constantly change
	// the currently program in use.
	// All the code below will affect directly the Program which is currently in use.
	glUseProgram(_program);
	
	// Sets the uniform to MVP Matrix.
	glUniformMatrix4fv(_uniforms[0], 1, GL_FALSE, matModelViewProjection);
	
	// Bind the texture to an Texture Unit.
	// Just to illustration purposes, in this case let's use the Texture Unit 7.
	// Remember which OpenGL gives 32 Texture Units.
	glActiveTexture(GL_TEXTURE7);
	glBindTexture(GL_TEXTURE_2D, _texture);

	
	// Sets the uniform to the desired Texture Unit.
	// As the Texture Unit used is 7, let's set this value to 7.
	glUniform1i(_uniforms[1], 7);
	
	// Bind the Buffer Objects which we'll use now.
	glBindBuffer(GL_ARRAY_BUFFER, _boStructure);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _boIndices);
	
	// Sets the dynamic attributes in the current shaders. Each attribute will start in a different
	// index of the ABO.
	glVertexAttribPointer(_attributes[0], 3, GL_FLOAT, GL_FALSE, _stride, (void *) 0);
	glVertexAttribPointer(_attributes[1], 2, GL_FLOAT, GL_FALSE, _stride, (void *) (3 * sizeof(GLfloat)));
	/*
     第一次调用是把空间坐标确定
     第二次调用是添加贴图
     */
    
    
    
	// Draws the triangles, starting by the index 0 in the IBO.
	glDrawElements(GL_TRIANGLES, _indicesCount, GL_UNSIGNED_SHORT, (void *) 0);
	
	// Unbid all the Buffer Objects currently in use. In this application this doesn't change anything.
	// But in a application with multiple Buffer Objects, this will be crucial.
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

/*!
 *	@function		render
 *	
 *	@abstract		Final step in the render process.
 */
void render(void)
{
	// Binds the necessary frame buffer and its color render buffer.
	glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _colorbuffer);
	
	// Call EAGL process to present the final image to the device's screen.
	[EAGLView presentColorbuffer];
}

#pragma mark -
#pragma mark Clear Methods
//**********************************************************************************************************
//
//  Clear Methods
//
//**********************************************************************************************************

/*!
 *	@function		clearOpenGL
 *	
 *	@abstract		Clears all OpenGL objects.
 */
void clearOpenGL(void)
{
	// Delete Buffer Objects.
	glDeleteBuffers(1, &_boStructure);
	glDeleteBuffers(1, &_boIndices);
	
	// Delete Programs, remember which the shaders was already deleted before.
	glDeleteProgram(_program);
	
	// Disable the previously enabled attributes to work with dynamic values.
	glDisableVertexAttribArray(_attributes[0]);
	glDisableVertexAttribArray(_attributes[1]);
	
	// Delete the Frame and Render buffers.
	glDeleteRenderbuffers(1, &_colorbuffer);
	glDeleteRenderbuffers(1, &_depthbuffer);
	glDeleteFramebuffers(1, &_framebuffer);
}

#pragma mark - changeMethods
void resetRotationAndSpeed()
{
    rotationX = 0;
    rotationY = 0;
    _speedX = 0;
    _speedY = 0;
    _scale = 1;
    _positionX = 0;
    _positionY = 0;
    //    _scaleY = 1;
}
void moveObj (float x, float y)
{
    _positionX = x/100;
    _positionY = y/100;
}

void setScale(float s)
{
    _scale = s;
    
}
void addSpeed(int x, int y)
{
    _speedX+=x;
    _speedY+=y;
}

#pragma mark -
#pragma mark Initialization
//**********************************************************************************************************
//
//  Initialization
//
//**********************************************************************************************************

/*!
 *	@function		initOpenGL
 *	
 *	@abstract		Initializes the OpenGL graphics library.
 *
 *	@discussion		This function makes the creation and all setups necessary to an OpenGL application.
 *
 *	@param			width
 *					The width in pixel of the final OpenGL view.
 *
 *	@param			height
 *					The height in pixel of the final OpenGL view.
 */
void initOpenGL(int width, int height)
{
    
    resetRotationAndSpeed();
//    _scale = 1;
	// Stores the size to this OpenGL application.
	_surfaceWidth = width;
	_surfaceHeight = height;
	
	// Creates all the OpenGL objects necessary to an application.
	createFrameAndRenderbuffers();
	createProgramAndShaders();
	createBufferObjects();
	createTexture();
	
	// Sets the size to OpenGL view.
	glViewport(0, 0, _surfaceWidth, _surfaceHeight);
}






