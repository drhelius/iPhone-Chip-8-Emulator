//
//  EAGLView.h
//  Chip8
//
//  Created by nacho on 14/02/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#pragma once

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#include "Game.h"
#import "Chip8AppDelegate.h"
#include "Util.h"
#include "Emulator.h"

/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView {
    
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
	
	CEmulator* m_pEmulator;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
	CGame* m_pGame;
	
	Chip8AppDelegate* delegate;
	
	//@public
	UIWindow *window;
}

@property NSTimeInterval animationInterval;
@property (nonatomic, assign) UIWindow* window;
@property (nonatomic, assign) Chip8AppDelegate* delegate;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end
