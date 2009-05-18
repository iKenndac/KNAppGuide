//
//  KNAppGuideAction.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 07/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
 
 The KNAppGuideAction protocol defines an action to be carried out
 by the user for a particular step in a guide, like "Click This Button".
 
 Actions are so different that it's pointless having a base class.
 
 Your custom action classes should be smart enough to know when the 
 user has performed the action themselves, and update the -hasBeenPerformed
 value in a KVO compatible manner. If the hasBeenPerformed property changes 
 from NO to YES while the action's step is the current step, the guide presenter will
 automatically move on to the next step. 
 
 Custom actions should also use this functionality to ensure they 
 don't perform an action again after the user has done it themselves, 
 especially if that action would replace the user's data with sample data.
 
 See the supplied action classes for examples on how to be aware of the user 
 performing actions.
 
 */

typedef enum {
	
	kAppGuideActionSuccessful = 0,
	kAppGuideActionAlreadyCompleted = 1,
	kAppGuideActionFailed = 2
	
} AppGuideActionResult;

@protocol KNAppGuideStep;

@protocol KNAppGuideAction 

-(AppGuideActionResult)performActionForStep:(id <KNAppGuideStep>)step; // Perform your action for the given step.
-(BOOL)hasBeenPerformed;
-(void)reset; // Reset to your base state. Set -hasBeenPerformed to NO, etc etc.

@end
