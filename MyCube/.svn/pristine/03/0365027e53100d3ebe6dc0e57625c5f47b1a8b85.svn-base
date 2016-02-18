

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark Global Properties
//**********************************************************************************************************
//
//  Global Properties
//
//**********************************************************************************************************

#define kPI		 3.141592	// PI
#define kPI180	 0.017453	// PI / 180
#define k180PI	57.295780	// 180 / PI

#pragma mark -
#pragma mark Global Functions
//**********************************************************************************************************
//
//  Global Functions
//
//**********************************************************************************************************

// Convert degrees to radians and vice versa.
#define degreesToRadians(x) (x * kPI180)
#define radiansToDegrees(x) (x * k180PI)

#pragma mark -
#pragma mark Definitions
//**********************************************************************************************************
//
//  Definitions
//
//**********************************************************************************************************

/*!
 *	@typedef		mat4
 *
 *	@discussion		A matrix of order 4 (4 columns by 4 rows) represented by a linear array of 16
 *					elements of float data type.
 *					OpenGL uses the matrix 4x4 to deal with complex operations in the 3D world, like
 *					rotations, translates and scales.
 *					A 4 x 4 matrix could be represented as following:
 *
 *					<pre>
 *					| 1  0  0  0 |
 *					|            |
 *					| 0  1  0  0 |
 *					|            |
 *					| 0  0  1  0 |
 *					|            |
 *					| 0  0  0  1 |
 *					</pre>
 *
 *					IMPORTANT:
 *
 *					OpenGL represents its matrices with the rows and columns swapped from the tradicional
 *					mathematical matrices (also know as column-major format). So in all the following
 *					code you'll see the SWAPPED MATRICES operations.
 *					
 *					The OpenGL uses one dimensional array ({0,1,2,3,4...}) to work with matricies, 
 *					so the indices of this matrix can be represented as following:
 *	
 *					<pre>
 *					  Tradicional                   OpenGL
 *					
 *					| 0  1  2  3  |             | 0  4  8  12 |
 *					|             |             |             |
 *					| 4  5  6  7  |             | 1  5  9  13 |
 *					|             |             |             |
 *					| 8  9  10 11 |             | 2  6  10 14 |
 *					|             |             |             |
 *					| 12 13 14 15 |             | 3  7  11 15 |
 *					</pre>
 */
typedef float mat4[16];

#pragma mark -
#pragma mark Functions
//**********************************************************************************************************
//
//  Functions
//
//**********************************************************************************************************

/*!
 *	@function		matrixIdentity
 *	
 *	@abstract		Sets the identity into a matrix.
 *
 *	@discussion		This method will completely replace the old values, if exist.
 *
 *	@param			m
 *					The matrix to receive the identity.
 */
void matrixIdentity(mat4 m)
{
	m[0] = m[5] = m[10] = m[15] = 1.0;
	m[1] = m[2] = m[3] = m[4] = 0.0;
	m[6] = m[7] = m[8] = m[9] = 0.0;
	m[11] = m[12] = m[13] = m[14] = 0.0;
}

/*!
 *	@function		matrixCopy
 *	
 *	@abstract		Makes a copy from a matrix.
 *
 *	@discussion		This method will copy the memory.
 *
 *	@param			original
 *					The matrix to be copied.
 *
 *	@param			result
 *					The resulting matrix.
 */
void matrixCopy(mat4 original, mat4 result)
{
	memcpy(result, original, sizeof(mat4));
}

/*!
 *	@function		matrixTranslate
 *	
 *	@abstract		Changes the translation of an already created matrix.
 *
 *	@discussion		The resulting matrix will continue with all its old values, translations
 *					doesn't change the other matrix components.
 *
 *	@param			x
 *					The translate in X axis.
 *
 *	@param			y
 *					The translate in Y axis.
 *
 *	@param			z
 *					The translate in Z axis.
 *
 *	@param			matrix
 *					The matrix to receive the resulting translate.
 */
void matrixTranslate(float x, float y, float z, mat4 matrix)
{
	// Translate slots.
	matrix[12] = x;
	matrix[13] = y;
	matrix[14] = z;   
}

/*!
 *	@function		matrixScale
 *	
 *	@abstract		Creates a scale matrix based on X, Y and Z scales.
 *
 *	@discussion		The resulting matrix has only this scale values, nothing more.
 *
 *	@param			x
 *					The scale in X axis. The default is 1.0.
 *
 *	@param			y
 *					The scale in Y axis. The default is 1.0.
 *
 *	@param			z
 *					The scale in Z axis. The default is 1.0.
 *
 *	@param			matrix
 *					The matrix to receive the resulting scaling.
 */
void matrixScale(float x, float y, float z, mat4 matrix)
{
	matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
	matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;
	matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
	matrix[15] = 1.0;
	
	// Scale slots.
	matrix[0] = x;
	matrix[5] = y;
	matrix[10] = z;
}

/*!
 *	@function		matrixRotateX
 *	
 *	@abstract		Creates a rotation matrix based on X rotation.
 *
 *	@discussion		The resulting matrix has only this rotation, nothing more.
 *
 *	@param			degrees
 *					The angle in degrees.
 *
 *	@param			matrix
 *					The matrix to receive the resulting rotation.
 */
void matrixRotateX(float degrees, mat4 matrix)
{
	float radians = degreesToRadians(degrees);
	
	matrix[1] = matrix[2] = matrix[3] = matrix[4] = matrix[7] = 0.0;
	matrix[8] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
	matrix[0] = matrix[15] = 1.0;
	
	// Rotate X formula.
	matrix[5] = cosf(radians);
	matrix[6] = -sinf(radians);
	matrix[9] = -matrix[6];
	matrix[10] = matrix[5];
}

/*!
 *	@function		matrixRotateY
 *	
 *	@abstract		Creates a rotation matrix based on Y rotation.
 *
 *	@discussion		The resulting matrix has only this rotation, nothing more.
 *
 *	@param			degrees
 *					The angle in degrees.
 *
 *	@param			matrix
 *					The matrix to receive the resulting rotation.
 */
void matrixRotateY(float degrees, mat4 matrix)
{
	float radians = degreesToRadians(degrees);
	
	matrix[1] = matrix[3] = matrix[4] = matrix[6] = matrix[7] = 0.0;
	matrix[9] = matrix[11] = matrix[13] = matrix[12] = matrix[14] = 0.0;
	matrix[5] = matrix[15] = 1.0;
	
	// Rotate Y formula.
	matrix[0] = cosf(radians);
	matrix[2] = sinf(radians);
	matrix[8] = -matrix[2];
	matrix[10] = matrix[0];
}

/*!
 *	@function		matrixRotateZ
 *	
 *	@abstract		Creates a rotation matrix based on Z rotation.
 *
 *	@discussion		The resulting matrix has only this rotation, nothing more.
 *
 *	@param			degrees
 *					The angle in degrees.
 *
 *	@param			matrix
 *					The matrix to receive the resulting rotation.
 */
void matrixRotateZ(float degrees, mat4 matrix)
{
	float radians = degreesToRadians(degrees);
	
	matrix[2] = matrix[3] = matrix[6] = matrix[7] = matrix[8] = 0.0;
	matrix[9] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
	matrix[10] = matrix[15] = 1.0;
	
	// Rotate Z formula.
	matrix[0] = cosf(radians);
	matrix[1] = sinf(radians);
	matrix[4] = -matrix[1];
	matrix[5] = matrix[0];
}

/*!
 *	@function		matrixPerspective
 *	
 *	@abstract		Multiplies two Matrices.
 *
 *	@discussion		The matrix multiplication is not commutative, so A x B != B x A.
 *
 *	@param			m1
 *					The first matrix to multiply.
 *
 *	@param			m2
 *					The matrix to be multiplied.
 *
 *	@param			result
 *					The matrix which will receive the result of the multiplication.
 */
void matrixMultiply(mat4 m1, mat4 m2, mat4 result)
{
	// Fisrt Column
	result[0] = m1[0] * m2[0] + m1[4] * m2[1] + m1[8] * m2[2] + m1[12] * m2[3];
	result[1] = m1[1] * m2[0] + m1[5] * m2[1] + m1[9] * m2[2] + m1[13] * m2[3];
	result[2] = m1[2] * m2[0] + m1[6] * m2[1] + m1[10] * m2[2] + m1[14] * m2[3];
	result[3] = m1[3] * m2[0] + m1[7] * m2[1] + m1[11] * m2[2] + m1[15] * m2[3];
	
	// Second Column
	result[4] = m1[0] * m2[4] + m1[4] * m2[5] + m1[8] * m2[6] + m1[12] * m2[7];
	result[5] = m1[1] * m2[4] + m1[5] * m2[5] + m1[9] * m2[6] + m1[13] * m2[7];
	result[6] = m1[2] * m2[4] + m1[6] * m2[5] + m1[10] * m2[6] + m1[14] * m2[7];
	result[7] = m1[3] * m2[4] + m1[7] * m2[5] + m1[11] * m2[6] + m1[15] * m2[7];
	
	// Third Column
	result[8] = m1[0] * m2[8] + m1[4] * m2[9] + m1[8] * m2[10] + m1[12] * m2[11];
	result[9] = m1[1] * m2[8] + m1[5] * m2[9] + m1[9] * m2[10] + m1[13] * m2[11];
	result[10] = m1[2] * m2[8] + m1[6] * m2[9] + m1[10] * m2[10] + m1[14] * m2[11];
	result[11] = m1[3] * m2[8] + m1[7] * m2[9] + m1[11] * m2[10] + m1[15] * m2[11];
	
	// Fourth Column
	result[12] = m1[0] * m2[12] + m1[4] * m2[13] + m1[8] * m2[14] + m1[12] * m2[15];
	result[13] = m1[1] * m2[12] + m1[5] * m2[13] + m1[9] * m2[14] + m1[13] * m2[15];
	result[14] = m1[2] * m2[12] + m1[6] * m2[13] + m1[10] * m2[14] + m1[14] * m2[15];
	result[15] = m1[3] * m2[12] + m1[7] * m2[13] + m1[11] * m2[14] + m1[15] * m2[15];
}

/*!
 *	@function		matrixPerspective
 *	
 *	@abstract		Creates the Projection Matrix.
 *
 *	@discussion		This function creates a new Buffer Object of a specific type based on a size and data.
 *
 *	@param			angle
 *					The angle of view in degrees.
 *
 *	@param			near
 *					The most near distance. 3D Objects outside it will be clamped.
 *
 *	@param			far
 *					The most far distance. 3D Objects outside it will be clamped.
 *
 *	@param			aspect
 *					The aspect ration of the screen. You can get it dividing the screen's width by the
 *					screen's height.
 *
 *	@param			matrix
 *					The mat4 variable wich will receive the Projection Matrix.
 */
void matrixPerspective(float angle, float near, float far, float aspect, mat4 matrix)
{
	float size = near * tanf(degreesToRadians(angle) / 2.0);
	float left = -size, right = size, bottom = -size / aspect, top = size / aspect;
	
	// Unused values in perspective formula.
	matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0;
	matrix[6] = matrix[7] = matrix[12] = matrix[13] = matrix[15] = 0;
	
	// Perspective formula.
	matrix[0] = 2 * near / (right - left);
	matrix[5] = 2 * near / (top - bottom);
	matrix[8] = (right + left) / (right - left);
	matrix[9] = (top + bottom) / (top - bottom);
	matrix[10] = -(far + near) / (far - near);
	matrix[11] = -1;
	matrix[14] = -(2 * far * near) / (far - near);
}