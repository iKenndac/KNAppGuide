//
//  KNAppGuideEnterDateAction.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 14/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideEnterDateAction.h"


@implementation KNAppGuideEnterDateAction

+(KNAppGuideEnterDateAction *)actionForDefaultDate:(NSDate *)date inDatePicker:(NSDatePicker *)aPicker {
	
	KNAppGuideEnterDateAction *action = [[KNAppGuideEnterDateAction alloc] init];
	
	if (aPicker) {
		[action setDatePicker:aPicker];
	}
	
	[action setDefaultDate:date];
	
	return [action autorelease];
	
}

@synthesize defaultDate;

-(AppGuideActionResult)performActionForStep:(id <KNAppGuideStep>)step {
	
	if (datePicker && !hasEnteredDate && [[self datePicker] isEnabled]) {
		
		[self willChangeValueForKey:@"hasBeenPerformed"];
		[datePicker setDateValue:[self defaultDate]];
		hasEnteredDate = YES;
		[self didChangeValueForKey:@"hasBeenPerformed"];
		
		return kAppGuideActionSuccessful;
		
	} else if (hasEnteredDate) {
		return kAppGuideActionAlreadyCompleted;
		
	} else {
		return kAppGuideActionFailed;
	}
	
}

- (void)textDidEndEditing:(NSNotification *)aNotification {
	
	[self willChangeValueForKey:@"hasBeenPerformed"];
	hasEnteredDate = YES;
	[self didChangeValueForKey:@"hasBeenPerformed"];
	
}

- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate **)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval {
	
	[self willChangeValueForKey:@"hasBeenPerformed"];
	hasEnteredDate = YES;
	[self didChangeValueForKey:@"hasBeenPerformed"];
}

-(void)setDatePicker:(NSDatePicker *)aPicker {
	
	if (datePicker) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidEndEditingNotification object:datePicker];
	}
	
	[datePicker setDelegate:nil];
	[aPicker retain];
	[datePicker release];
	
	datePicker = aPicker;
	[datePicker setDelegate:self];
	
	if (datePicker) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(textDidEndEditing:)
													 name:NSControlTextDidEndEditingNotification
												   object:datePicker];
	}
	
}

-(NSDatePicker *)datePicker {
	return datePicker;
}

-(void)reset {
	[self willChangeValueForKey:@"hasBeenPerformed"];
	hasEnteredDate = NO;
	[self didChangeValueForKey:@"hasBeenPerformed"];
}

-(BOOL)hasBeenPerformed {
	return hasEnteredDate;
}

-(void)dealloc {
	
	[self setDatePicker:nil];
	[self setDefaultDate:nil];
	
	[super dealloc];
}


@end
