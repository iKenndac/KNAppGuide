//
//  KNAppGuideEnterDateAction.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 14/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KNAppGuideAction.h"

@interface KNAppGuideEnterDateAction : NSObject <KNAppGuideAction> {
	
	NSDatePicker *datePicker;
	BOOL hasEnteredDate;
	NSDate *defaultDate;
	
}

+(KNAppGuideEnterDateAction *)actionForDefaultDate:(NSDate *)date inDatePicker:(NSDatePicker *)aPicker;

@property (copy, readwrite, nonatomic) NSDate *defaultDate;

-(void)setDatePicker:(NSDatePicker *)aPicker;
-(NSDatePicker *)datePicker;


@end
