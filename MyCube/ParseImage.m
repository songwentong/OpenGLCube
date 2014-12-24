

#import "ParseImage.h"

@implementation ParseImage

#pragma mark -
#pragma mark Properties
//**********************************************************************************************************
//
//  Properties
//
//**********************************************************************************************************

@synthesize width = _width, height = _height, data = _data;

#pragma mark -
#pragma mark Initialization
//**********************************************************************************************************
//
//  Initialization
//
//**********************************************************************************************************

- (instancetype) initWithImage:(UIImage *)uiImage
{
	if ((self = [self init]))
	{
		CGImageRef cgImage;
		CGContextRef context;
		CGColorSpaceRef	colorSpace;
		
		// Sets the CoreGraphic Image to work on it.
		cgImage = [uiImage CGImage];
		
		// Sets the image's size.
		_width = CGImageGetWidth(cgImage);
		_height = CGImageGetHeight(cgImage);
		
		// Extracts the pixel informations and place it into the data.
        /*
         每个容器装8个像素
         */
		colorSpace = CGColorSpaceCreateDeviceRGB();
		_data = malloc(_width * _height * 4);
		context = CGBitmapContextCreate(_data, _width, _height, 8, 4 * _width, colorSpace,
										kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		CGColorSpaceRelease(colorSpace);
		
		// Adjusts position and invert the image.
		// The OpenGL uses the image data upside-down compared commom image files.
		CGContextTranslateCTM(context, 0, _height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		// Clears and ReDraw the image into the context.
		CGContextClearRect(context, CGRectMake(0, 0, _width, _height));
		CGContextDrawImage(context, CGRectMake(0, 0, _width, _height), cgImage);
		
		// Releases the context.
		CGContextRelease(context);
	}
	
	return self;
}

#pragma mark -
#pragma mark Override Public Methods
//**********************************************************************************************************
//
//  Override Public Methods
//
//**********************************************************************************************************


- (void) dealloc
{
	free(_data);
	
}

@end