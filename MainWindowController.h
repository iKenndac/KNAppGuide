//
//  MainWindowController.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNAppGuide/KNAppGuide.h>

@interface MainWindowController : NSWindowController <KNAppGuidePresenterDelegate> {
	IBOutlet NSButton *saveButton;
	IBOutlet NSTextField *nameField;
	IBOutlet NSToolbarItem *toolbarItem;
	IBOutlet NSDatePicker *datePicker;
	IBOutlet NSMenuItem *aMenuItem;
	
	// This ivar is here so Garbage Collection doesn't collect
	// our presented prematurely. If you're not using GC, the 
	// presenter will retain itself so you don't need to bother. 
	id <KNAppGuidePresenter> presenter;
	
	BOOL datePickerIsHidden;
}

@property BOOL datePickerIsHidden;

-(IBAction)startGuideFromFile:(id)sender;
-(IBAction)startGuideFromCode:(id)sender;

-(IBAction)clickButton:(id)sender;
-(IBAction)clickToolbarItem:(id)sender;
-(IBAction)chooseMenuItem:(id)sender;

@end
