

#import "EAGLView.h"
#import "CubeExample.mm"

#pragma mark -
#pragma mark Global Properties
//**********************************************************************************************************
//
//  Global Properties
//
//**********************************************************************************************************

// The number of Frames Per Second which this application will run.
#define FPS			60

// Holds a Global variable to access the UIView.
static EAGLView *eagl;

// Holds a Global variable to access the parsed texture.
static ParseImage *parseImage;

#pragma mark -
#pragma mark Implementation
//**********************************************************************************************************
//
//  Implementation
//
//**********************************************************************************************************

@implementation EAGLView

#pragma mark -
#pragma mark Initialization
//**********************************************************************************************************
//
//  Initialization
//
//**********************************************************************************************************

- (id)init
{
	if ((self = [super init]))
	{
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		// Set the properties to EAGL.
		// If the color format here is set to kEAGLColorFormatRGB565, you'll not be able
		// to use texture with alpha in this EAGLLayer.
        eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
										nil];
		
		// Set this EAGLView to be accessed later on.
		eagl = self;
        [self addGestureRecognizers];
		
		// Parses this image which is in main bundle.
		parseImage = [[ParseImage alloc] initWithImage:[UIImage imageNamed:@"cube_example.jpg"]];
    }
	
    return self;
}

#pragma mark -
#pragma mark Self Public Methods
//**********************************************************************************************************
//
//  Self Public Methods
//
//**********************************************************************************************************

- (void) renderFrame
{
	// Pre-Rendering step.
	preRender();
	
	// Drawing step.
	drawScene();
	
	// Render step.
	render();
}

#pragma mark -
#pragma mark Self Class Methods
//**********************************************************************************************************
//
//  Self Class Methods
//
//**********************************************************************************************************

+ (void) propertiesToCurrentColorbuffer
{
	// Sets the properties to the currently bound Color Renderbuffer based on the EAGLContext in use.
	[[EAGLContext currentContext] renderbufferStorage:GL_RENDERBUFFER
										 fromDrawable:(CAEAGLLayer *)eagl.layer];
}


+ (void) presentColorbuffer
{
	// Presents the currently bound Color Renderbuffer to to the EAGLContext in use.
	[[EAGLContext currentContext] presentRenderbuffer:GL_RENDERBUFFER];
}

+ (ParseImage *) image
{
	// Gives access to the parsed image.
	return parseImage;
}

#pragma mark -
#pragma mark Override Public Methods
//**********************************************************************************************************
//
//  Override Public Methods
//
//**********************************************************************************************************

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	// Starts a UIWindow with the size of the device's screen.
	CGRect rect = [[UIScreen mainScreen] bounds];	
	_window = [[UIWindow alloc] initWithFrame:rect];
	
	if(!(self = [super initWithFrame:rect])) 
	{
		[self release];
		return;
	}
	
	// Makes that UIWindow the key window and show it. Additionaly add this UIView to it.
	[_window makeKeyAndVisible];
	[_window addSubview:self];
	
	// Creates the EAGLContext and set it as the current one.
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	[EAGLContext setCurrentContext:_context];
	
	// Initializes the OpenGL in the CubeExample.mm
	initOpenGL(self.bounds.size.width, self.bounds.size.height);
	
	// Creates a loop routine to execute the OpenGL render "FPS" times per second.
	[NSTimer scheduledTimerWithTimeInterval:(1.0 / FPS) 
									 target:self
								   selector:@selector(renderFrame)
								   userInfo:nil
									repeats:YES];	
}

+ (Class) layerClass
{
	// This is mandatory to work with CAEAGLLayer in Cocoa Framework.
    return [CAEAGLLayer class];
}

- (void)dealloc
{
	clearOpenGL();
	[_context release];
	[_window release];
	[parseImage release];
	
	eagl = nil;
	parseImage = nil;
	
    [super dealloc];
}

#pragma mark - 
-(void)addGestureRecognizers
{
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:right];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:up];
    
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    down.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:down];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    tap.numberOfTouchesRequired = 3;
    [self addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    [self addGestureRecognizer:pin];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    pan.minimumNumberOfTouches = 2;
    [self addGestureRecognizer:pan];
}

-(void)reciveGesture:(UIGestureRecognizer*)recognizer
{
    if ([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        UISwipeGestureRecognizer *reco = (UISwipeGestureRecognizer*)recognizer;
        if (reco.direction == UISwipeGestureRecognizerDirectionRight) {
            addSpeed(0, -2);
        }
        if (reco.direction == UISwipeGestureRecognizerDirectionLeft) {
            addSpeed(0, 2);
        }
        if (reco.direction == UISwipeGestureRecognizerDirectionUp) {
            addSpeed(-2, 0);
        }
        if (reco.direction == UISwipeGestureRecognizerDirectionDown) {
            addSpeed(2, 0);
        }
    }// end swipe
    
    if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        resetRotationAndSpeed();
    }// end tap
    
    if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *pin = (UIPinchGestureRecognizer*)recognizer;
        setScale(pin.scale);
    } // end pin scale
    
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)recognizer;
        CGPoint p = [pan translationInView:self];
        NSLog(@"%f,%f",p.x,p.y);
        move(p.x, -p.y);
    }
}


@end
