//
//  KNAppGuideClickButtonAction.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNAppGuide/KNAppGuideAction.h>

@interface KNAppGuideClickButtonAction : NSObject <KNAppGuideAction> {
	BOOL hasClickedButton;
	
	id actionButton;
	id buttonTarget;
	SEL buttonAction;
}

+(KNAppGuideClickButtonAction *)actionForButton:(id)aButton;

-(IBAction)actionButtonWasClicked:(id)sender;

-(void)setButton:(id)aButton;
-(id)button;

@end
