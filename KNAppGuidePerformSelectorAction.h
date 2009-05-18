//
//  KNAppGuidePerformSelectorAction.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 14/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KNAppGuideAction.h"

@interface KNAppGuidePerformSelectorAction : NSObject <KNAppGuideAction> {

	id target;
	NSString *action;
	// ^ Store the action as a string so it can easily be loaded from file and set through KVC
	
	BOOL actionWasPerformed;
	
}

+(KNAppGuidePerformSelectorAction *)actionForTarget:(id)aTarget action:(NSString *)anAction;

@property (readwrite, nonatomic, retain) id target;
@property (readwrite, nonatomic, copy) NSString *action;

@end
