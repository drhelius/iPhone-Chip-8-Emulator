//
//  EAGLView.m
//  Chip8
//
//  Created by nacho on 14/02/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize window;
@synthesize delegate;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = REDRAW_INTERVAL;
    }
    return self;
}


- (void)drawView {
    
	
    
        
	///////////////////////
	
    m_pGame->Tick();
	
	///////////////////////    
	
    

}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
	
	m_pGame = new CGame(delegate,  backingWidth, backingHeight, viewRenderbuffer, viewFramebuffer, context);
	
	m_pEmulator = m_pGame->Init();
	
	m_pGame->SetWindow(self.window);
	
	[ NSThread detachNewThreadSelector: @selector(emulatorLoop) toTarget: self withObject: nil ];
	
    return YES;
	
}

- (void)emulatorLoop;
{
	m_pEmulator->Go();
}

- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}
/*
- (void)setWindow:(UIWindow*)win {
    
    window = win;
	}


- (UIWindow*)window {
    
    return self->window;	
}

- (void)setDelegate:(Chip8AppDelegate*)del {
    
    delegate = del;
	
}

- (Chip8AppDelegate*)delegate {
    
    return self->delegate;	
}

*/
- (void)dealloc {
    
    [self stopAnimation];
	
	m_pGame->End();	
	
	SafeDelete(m_pGame);
	
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
[super dealloc];}

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	CGPoint location = [touch locationInView:self];
	//location.y = bounds.size.height - location.y;
	
	m_pGame->Tap(location.x, location.y);
	/*
	 //draw a little message 
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simple Alert" message:@"Bringing knowledge from XCode.es to you since 2008, visit our web" delegate:self defaultButton:@"OK" cancelButton:@"Cancelar" otherButtons:nil];
	 
	 [alert show];
	 [alert release];*/
	/*
	 UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Your score is 516489" 
	 message:@"You can submit it to the worldwide scoreboard. Enter your name:"
	 delegate:self cancelButtonTitle:@"Cancel" 
	 otherButtonTitles:@"Submit", nil];
	 [alert addTextFieldWithValue:@"" label:nil];
	 //[alert textField].keyboardType = UIKeyboardTypeNumberPad;
	 //alert.tag = kMyAlert;
	 [alert show];
	 [alert release];*/
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{ 
	
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	CGPoint location = [touch locationInView:self];
	//location.y = bounds.size.height - location.y;
	
	m_pGame->Touch(location.x, location.y);
	/*
	 CGRect				bounds = [self bounds];
	 UITouch*			touch = [[event touchesForView:self] anyObject];
	 
	 //Convert touch point from UIView referential to OpenGL one (upside-down flip)
	 if (firstTouch) {
	 firstTouch = NO;
	 previousLocation = [touch previousLocationInView:self];
	 previousLocation.y = bounds.size.height - previousLocation.y;
	 } else {
	 location = [touch locationInView:self];
	 location.y = bounds.size.height - location.y;
	 previousLocation = [touch previousLocationInView:self];
	 previousLocation.y = bounds.size.height - previousLocation.y;
	 }
	 
	 // Render the stroke
	 [self renderLineFromPoint:previousLocation toPoint:location];
	 */
	
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	/*
	 CGRect				bounds = [self bounds];
	 UITouch*	touch = [[event touchesForView:self] anyObject];
	 if (firstTouch) {
	 firstTouch = NO;
	 previousLocation = [touch previousLocationInView:self];
	 previousLocation.y = bounds.size.height - previousLocation.y;
	 [self renderLineFromPoint:previousLocation toPoint:location];
	 }
	 */
	
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	CGPoint location = [touch locationInView:self];
	//location.y = bounds.size.height - location.y;
	
	m_pGame->TouchEnd(location.x, location.y);
	
	
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}


@end
