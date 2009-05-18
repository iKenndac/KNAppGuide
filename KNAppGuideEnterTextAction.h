//
//  KNAppGuideEnterTextAction.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNAppGuide/KNAppGuideAction.h>

@interface KNAppGuideEnterTextAction : NSObject <KNAppGuideAction> {

	NSTextField *textField;
	BOOL hasEnteredText;
	NSString *defaultText;
	
}

+(KNAppGuideEnterTextAction *)actionForDefaultText:(NSString *)text inTextField:(NSTextField *)aField;

@property (copy, readwrite, nonatomic) NSString *defaultText;

-(void)setTextField:(NSTextField *)aField;
-(NSTextField *)textField;

@end
