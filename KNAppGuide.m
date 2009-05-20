//
//  KNAppGuide.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 07/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuide.h"

@implementation KNAppGuide

+(id <KNAppGuide>)guideFromFile:(NSString *)string resolver:(id <KNAppGuideResolver>)aResolver {
	return [KNAppGuideLoader guideFromFile:string resolver:aResolver];
}

+(id <KNAppGuide>)guideFromBundle:(NSBundle *)bundle withName:(NSString *)name resolver:(id <KNAppGuideResolver>)aResolver {
	return [KNAppGuideLoader guideFromBundle:bundle withName:name resolver:aResolver];
}

+(id <KNAppGuide>)guideWithName:(NSString *)name resolver:(id <KNAppGuideResolver>)aResolver {
	return [KNAppGuideLoader guideWithName:name resolver:aResolver];
}

static NSString *guideKVOContext = @"guideKVO";

-(id)init {
	
	if (self = [super init]) {
		
		[self addObserver:self 
			   forKeyPath:@"steps" 
				  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
				  context:guideKVOContext];
	}
	return self;
}

@synthesize currentStep;
@synthesize steps;
@synthesize delegate;
@synthesize title;
@synthesize identifier;

+(NSSet *)keyPathsForValuesAffectingHasFinished {
	return [NSSet setWithObjects:@"currentStep", nil];
}

-(BOOL)hasFinished {
	return [self currentStep] == [[self steps] lastObject];
}

+(NSSet *)keyPathsForValuesAffectingIsAtBeginning {
	return [NSSet setWithObjects:@"currentStep", nil];
}


-(BOOL)isAtBeginning {
	if ([[self steps] count] > 0) {
		return [self currentStep] == [[self steps] objectAtIndex:0];
	} else {
		return NO;
	}
}

-(BOOL)moveToPreviousStep {
	
	if (![self isAtBeginning]) {
		
		// Don't need to check and perform actions, since we're going backwards through steps we've already done.
		
		KNAppGuideStep *prevStep = nil;
		
		if ([self currentStep]) {
			NSInteger index = [[self steps] indexOfObject:[self currentStep]];
			prevStep = [[self steps] objectAtIndex:index - 1];
		} else if ([[self steps] count] > 0) {
			prevStep = [[self steps] objectAtIndex:0];
		} else {
			return NO;
		}
		
		if ([[self delegate] respondsToSelector:@selector(guide:willMoveToStep:)]) {
			[[self delegate] guide:self willMoveToStep:prevStep];
		}
		[self setCurrentStep:prevStep];
		[prevStep stepWillBeShown];
		
		if ([[self delegate] respondsToSelector:@selector(guide:didMoveToStep:)]) {
			[[self delegate] guide:self didMoveToStep:prevStep];
		}
		
		return YES;
	}
	
	return NO;
	
}


-(BOOL)moveToNextStep {
	
	if (![self hasFinished]) {
		if ([[self currentStep] completionRequiredForNextStep] && ![[[self currentStep] action] hasBeenPerformed]) {
		
			[(NSObject *)[self currentStep] removeObserver:self forKeyPath:@"action.hasBeenPerformed"];
			
			// ^ Remove the observer so it doesn't trigger an automatic move to the next action
			
			AppGuideActionResult result = [[self currentStep] performAction];
			
			[(NSObject *)[self currentStep] addObserver:self 
								 forKeyPath:@"action.hasBeenPerformed"
									options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
									context:guideKVOContext];
			
			if (result == kAppGuideActionFailed) {
				return NO;
			}
		}
		
		KNAppGuideStep *nextStep = nil;
		
		if ([self currentStep]) {
			NSInteger index = [[self steps] indexOfObject:[self currentStep]];
			nextStep = [[self steps] objectAtIndex:index + 1];
		} else if ([[self steps] count] > 0) {
			nextStep = [[self steps] objectAtIndex:0];
		} else {
			return NO;
		}
		
		if ([[self delegate] respondsToSelector:@selector(guide:willMoveToStep:)]) {
			[[self delegate] guide:self willMoveToStep:nextStep];
		}
		
		[self setCurrentStep:nextStep];
		[nextStep stepWillBeShown];
		
		if ([[self delegate] respondsToSelector:@selector(guide:didMoveToStep:)]) {
			[[self delegate] guide:self didMoveToStep:nextStep];
		}
		
		return YES;
	}
	
	return NO;
}

-(void)reset {
	if ([[self steps] count] > 0) {
		
		for (KNAppGuideStep *step in [self steps]) {
			[step reset];
		}
		
		KNAppGuideStep *step = [[self steps] objectAtIndex:0];
		
		if ([[self delegate] respondsToSelector:@selector(guide:willMoveToStep:)]) {
			[[self delegate] guide:self willMoveToStep:step];
		}
		
		[self setCurrentStep:step];
		[step stepWillBeShown];
		
		if ([[self delegate] respondsToSelector:@selector(guide:didMoveToStep:)]) {
			[[self delegate] guide:self didMoveToStep:step];
		}
	} else {
		[self setCurrentStep:nil];
	}
}

#pragma mark -
#pragma mark KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == guideKVOContext) {
		
		if ([keyPath isEqualToString:@"steps"]) {
			
			id oldSteps = [change valueForKey:NSKeyValueChangeOldKey];
			
			if (oldSteps != [NSNull null]) {
				for (id item in oldSteps) {
					[item removeObserver:self forKeyPath:@"action.hasBeenPerformed"];
				}
			}
			
			id newSteps = [change valueForKey:NSKeyValueChangeNewKey];
			
			if (newSteps != [NSNull null]) {
				for (id item in newSteps) {
					[item addObserver:self 
						   forKeyPath:@"action.hasBeenPerformed"
							  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
							  context:guideKVOContext];
				}
			}
			
		}
		
		if ([keyPath isEqualToString:@"action.hasBeenPerformed"]) {
			
			if ([[self delegate] respondsToSelector:@selector(guide:action:wasPerformedForStep:)]) {
				[[self delegate] guide:self action:(id <KNAppGuideAction>)[object action] wasPerformedForStep:(id <KNAppGuideStep>)object];
			}
			
			if (object == [self currentStep]) {
				[self moveToNextStep];
			}
			
		}
		
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark -

-(void)dealloc {
	
	[self setDelegate:nil];
	[self setCurrentStep:nil];
	[self setSteps:nil];
	
	[self removeObserver:self forKeyPath:@"steps"];
	
	[super dealloc];
	
}

@end
