//
//  Chip8AppDelegate.h
//  Chip8
//
//  Created by nacho on 14/02/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#pragma once

#import <UIKit/UIKit.h>
#include "Util.h"

@class EAGLView;

@interface Chip8AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end

