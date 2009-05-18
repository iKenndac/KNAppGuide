//
//  KNAppGuideStep.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 07/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNAppGuide/KNAppGuideAction.h>

/*
 
 The KNAppGuideStep class represents a step in a guide, and contains an explanation, a highlighted item 
 and an action.
 
Just like the KNAppGuide class and protocol pair, you can use custom classes for steps as long
 as they implement the KNAppGuideStep protocol.
 
 -action and -highlightedItem can happily be nil.
 
 If -completionRequiredForNextStep returns YES, the framework will attempt to perform the step's action
 before moving to the next step.
 
 */

@class KNAppGuideStep;

@protocol KNAppGuideStep <NSObject>

@property BOOL completionRequiredForNextStep;
@property (copy, nonatomic, readwrite) NSString *explanation;
@property (retain, nonatomic, readwrite) id <KNAppGuideAction> action;
@property (retain, nonatomic, readwrite) id highlightedItem;

-(void)stepWillBeShown;
-(AppGuideActionResult)performAction;
-(void)reset;

@end

@interface KNAppGuideStep : NSObject <KNAppGuideStep> {

	BOOL completionRequiredForNextStep;
	NSString *explanation;
	id <KNAppGuideAction> action;
	id highlightedItem;
	
}

+(KNAppGuideStep *)stepWithExplanation:(NSString *)anExplanation action:(id <KNAppGuideAction>)anAction highlightedItem:(id)anItem;

@end
