//
//  KNAppGuideHUDPresenter.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 13/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNAppGuide/KNAppGuidePresenter.h>
#import <KNAppGuide/KNAppGuideDelegate.h>

//@protocol KNAppGuideDelegate;
@class KNAppGuideClassicHighlight;

@interface KNAppGuideHUDPresenter : NSWindowController <KNAppGuidePresenter, KNAppGuideDelegate> {
	id <KNAppGuide> guide;
	id <KNAppGuidePresenterDelegate> delegate;
	KNAppGuideClassicHighlight *currentControlHighlight;
	IBOutlet NSTextField *stepExplanationTextField;
	IBOutlet NSButton *nextButton;
}

-(IBAction)clickNext:(id)sender;
-(IBAction)clickPrevious:(id)sender;
-(IBAction)clickPerformAction:(id)sender;

-(void)sizeWindowToFit;

@end
