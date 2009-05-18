//
//  KNAppGuideEnterTextAction.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideEnterTextAction.h"


@implementation KNAppGuideEnterTextAction

+(KNAppGuideEnterTextAction *)actionForDefaultText:(NSString *)text inTextField:(NSTextField *)aField {
	
	KNAppGuideEnterTextAction *action = [[KNAppGuideEnterTextAction alloc] init];
	
	if (aField) {
		[action setTextField:aField];
	}
	
	[action setDefaultText:text];
	
	return [action autorelease];
	
}

@synthesize defaultText;

-(AppGuideActionResult)performActionForStep:(id <KNAppGuideStep>)step {
	
	if (textField && !hasEnteredText) {
		
		[self willChangeValueForKey:@"hasBeenPerformed"];
		[textField setStringValue:[self defaultText]];
		hasEnteredText = YES;
		[self didChangeValueForKey:@"hasBeenPerformed"];
		
		return kAppGuideActionSuccessful;
		
	} else if (hasEnteredText) {
		return kAppGuideActionAlreadyCompleted;
		
	} else {
		return kAppGuideActionFailed;
	}
	
}

- (void)textDidEndEditing:(NSNotification *)aNotification {
	
	[self willChangeValueForKey:@"hasBeenPerformed"];
	hasEnteredText = YES;
	[self didChangeValueForKey:@"hasBeenPerformed"];
	
}

-(void)setTextField:(NSTextField *)aField {
	
	if (textField) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidEndEditingNotification object:textField];
	}
	
	[aField retain];
	[textField release];
	
	textField = aField;
	
	if (textField) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(textDidEndEditing:)
													 name:NSControlTextDidEndEditingNotification
												   object:textField];
	}
	
}

-(NSTextField *)textField {
	return textField;
}

-(void)reset {
	[self willChangeValueForKey:@"hasBeenPerformed"];
	hasEnteredText = NO;
	[self didChangeValueForKey:@"hasBeenPerformed"];
}

-(BOOL)hasBeenPerformed {
	return hasEnteredText;
}

-(void)dealloc {
	
	[self setTextField:nil];
	[self setDefaultText:nil];
	
	[super dealloc];
}


@end
