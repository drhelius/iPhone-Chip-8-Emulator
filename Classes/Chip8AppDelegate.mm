//
//  Chip8AppDelegate.m
//  Chip8
//
//  Created by nacho on 14/02/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Chip8AppDelegate.h"
#import "EAGLView.h"
#include "SoundEngine.h"

@implementation Chip8AppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	AudioSessionInitialize(nil, nil, nil, nil); 
	
	UInt32 isPlaying = 0;
	UInt32 propertySize = sizeof (isPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &isPlaying);
	
	if (isPlaying != 0)
	{
		UInt32 category = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
	}
    SoundEngine_Initialize(22050);
	//SoundEngine_Initialize(44100);
	SoundEngine_SetListenerPosition(0.0, 0.0, 1.0);
	
	glView.animationInterval = REDRAW_INTERVAL;
	[glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = REDRAW_INTERVAL;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = REDRAW_INTERVAL;
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
