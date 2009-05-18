//
//  KNAppGuide.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 07/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Import everything so clients can just import <KNAppGuide/KNAppGuide.h> to use the framework

#import <KNAppGuide/KNAppGuideDelegate.h>

// Steps
#import <KNAppGuide/KNAppGuideStep.h>

// Actions
#import <KNAppGuide/KNAppGuideAction.h>
#import <KNAppGuide/KNAppGuideClickButtonAction.h>
#import <KNAppGuide/KNAppGuideEnterTextAction.h>
#import <KNAppGuide/KNAppGuideEnterDateAction.h>
#import <KNAppGuide/KNAppGuidePerformSelectorAction.h>

// Loading and Resolving

#import <KNAppGuide/KNAppGuideLoader.h>
#import <KNAppGuide/KNAppGuideResolver.h>
#import <KNAppGuide/KNAppGuideBasicKVCResolver.h>

// Presenting 

#import <KNAppGuide/KNAppGuidePresenter.h>
#import <KNAppGuide/KNAppGuideHUDPresenter.h>

/*
 
 The KNAppGuide class represents a guide's content, and contains
 a title, an identifier, and an array of KNAppGuideStep objects.
 
 The framework is designed to be as customisable as possible, so you can have a custom 
 guide class if you prefer. As long as the class implements the KNAppGuide protocol it'll 
 work with the rest of the framework, but for most cases you'll probably just want to subclass the
 KNappGuide class.
 
 Guides can be made in code by creating and setting the required objects, 
 or from file using the methods in KNAppGuideLoader. KNappGuide provides 
 convenience methods for loading from file that pass through to KNAppGuideLoader.
 
 KNAppGuideLoader is fairly smart about using your custom guide, step and action classes where needed.
 For more information on loading from file, see the KNAppGuideLoader header.
 
 */

@protocol KNAppGuide <NSObject>

@property (copy, nonatomic, readwrite) NSString *title;
@property (copy, nonatomic, readwrite) NSString *identifier;
@property (retain, nonatomic, readwrite) NSArray *steps;
@property (retain, nonatomic, readwrite) id <KNAppGuideStep>currentStep;
@property (assign, nonatomic, readwrite) id <KNAppGuideDelegate> delegate;

-(BOOL)hasFinished;
-(BOOL)isAtBeginning;
-(BOOL)moveToNextStep;
-(BOOL)moveToPreviousStep;
-(void)reset;

@end

@interface KNAppGuide : NSObject <KNAppGuide> {
	
	id <KNAppGuideStep> currentStep;
	NSArray *steps;
	id <KNAppGuideDelegate> delegate;
	NSString *title;
	NSString *identifier;
	
}

+(id <KNAppGuide>)guideFromFile:(NSString *)string resolver:(id <KNAppGuideResolver>)aResolver;
+(id <KNAppGuide>)guideFromBundle:(NSBundle *)bundle withName:(NSString *)name resolver:(id <KNAppGuideResolver>)aResolver;
+(id <KNAppGuide>)guideWithName:(NSString *)name resolver:(id <KNAppGuideResolver>)aResolver;

@end
