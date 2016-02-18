

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 *	@class			ParseImage
 *	
 *	@abstract		This class is responsible by parse image files.
 *
 *	@discussion		The outputs will be the image's size (width and height) and the
 *					binarized array of pixels.
 */
@interface ParseImage : NSObject
{
@private
	int					_width;
	int					_height;
	void				*_data;
}

/*!
 *	@discussion		The width in pixels.
 */
@property (nonatomic, readonly) int width;

/*!
 *	@discussion		The height in pixels.
 */
@property (nonatomic, readonly) int height;

/*!
 *	@discussion		The array of pixels.
 */
@property (nonatomic, readonly) void *data;


/*!
 *	@method			initWithImage:
 *
 *	@abstract		Initiates the parsing based on an UIImage.
 *
 *	@discussion		This method parses an image using 4 bytes per pixel. The output format will be RGBA
 *
 *	@param			uiImage
 *					The UIImage instance to be parsed.
 */
- (id) initWithImage:(UIImage *)uiImage;

@end