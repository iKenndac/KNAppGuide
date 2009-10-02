//
//  MainWindowController.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "MainWindowController.h"
#import "KNToolBarExtensions.h"

@implementation MainWindowController

@synthesize datePickerIsHidden;

-(IBAction)startGuideFromFile:(id)sender {

	// This method instantiates a guide from the sample guide file included in the demo app and runs it.
	
	id <KNAppGuide> guide = [KNAppGuide guideWithName:@"Sample Guide.plist" 
							 resolver:[KNAppGuideBasicKVCResolver basicResolverWithBaseObject:self]];
	
	presenter = [[KNAppGuideHUDPresenter alloc] initWithGuide:guide];
	[presenter setDelegate:self];
	[presenter beginPresentation];
	
}

-(void)presenter:(id <KNAppGuidePresenter>)aPresenter didFinishPresentingGuide:(id <KNAppGuide>)aGuide completed:(BOOL)wasCompleted {
	// Called after the window is closed

	if (aPresenter == presenter) {
		[presenter release];
		presenter = nil;
	}
}

-(IBAction)startGuideFromCode:(id)sender { 
		
	// This method instantiates a guide, adds steps manually and runs it.
	
	id <KNAppGuide> guide = [[KNAppGuide alloc] init];
	
	[guide setTitle:@"KNAppGuide Guide"];
	
	id <KNAppGuideStep> step1 = [KNAppGuideStep stepWithExplanation:@"Welcome to the KNAppGuide demo application. This guide was created in code in the startGuideFromCode: "
																	@"method in MainWindowController, and will walk you through the framework's "
																	@"features and structure.\n\nTo get started, click the → button."
															 action:[KNAppGuideClickButtonAction actionForButton:aMenuItem]
													highlightedItem:aMenuItem];
	
	id <KNAppGuideStep> step2 = [KNAppGuideStep stepWithExplanation:@"This HUD is where the user interacts with the guide. It has a few simple controls: \n\n"
																	@"• The ← button goes back to the previous step.\n"
																	@"• The “Show Me” button performs the action the guide is asking the user to do, if available.\n"
																	@"• The → button moves on to the next step. If the current step is mandatory, the action is performed for the user first.\n"
																	@"• The ✔ button, which replaces the → button at the end of the guide, completes the guide." 
															 action:nil
													highlightedItem:nil];
	
	id <KNAppGuideStep> step3 = [KNAppGuideStep stepWithExplanation:@"Hopefully you noticed the red circle highlighting the “Your Name” field. This is a "
																	@"view highlight, and currently supports views and toolbar items. \n\n"
																	@"Clicking the “Show Me” button will automatically fill in the field with some sample text. "
																	@"As this step isn't mandatory to whatever we're doing, clicking the → button will move to the "
																	@"next step without filling in the sample text."
															 action:[KNAppGuideEnterTextAction actionForDefaultText:@"Some Sample Text" inTextField:nameField] 
													highlightedItem:nameField];
	
	id <KNAppGuideStep> step4 = [KNAppGuideStep stepWithExplanation:@"Here we're just highlighting a toolbar item for the sake of it. However, this is "
																	@"a good time to point out that wherever possible, you should have your custom actions be "
																	@"able to recognise when they've been performed by the user in your UI. That way, the guide "
																	@"will be able to progress without the user having to return to this window to click the → button "
																	@"each time.\n\nNearly all of the built-in actions support this. Click the toolbar item to see this "
																	@"functionality in action."
															 action:[KNAppGuideClickButtonAction actionForButton:toolbarItem]
													highlightedItem:toolbarItem];
	
	
	id <KNAppGuideStep> step5 = [KNAppGuideStep stepWithExplanation:@"This action is mandatory. If you enter a date into the highlighted picker, the guide "
																	@"will move on to the next step automatically. However, if you don't, a sample value "
																	@"will be entered for you when you click the → button.\n\n"
																	@"Note: If you changed the date in this picker while the guide was on another step, the "	
																	@"sample value won't be entered and the “Show Me” button will be dimmed so the guide doesn't "
																	@"replace the user's real data with our fake data."
															 action:[KNAppGuideEnterDateAction actionForDefaultDate:[NSDate date] inDatePicker:datePicker]
													highlightedItem:datePicker];
	[step5 setCompletionRequiredForNextStep:YES];
	
	id <KNAppGuideStep> step6 = [KNAppGuideStep stepWithExplanation:@"KNAppGuide uses a plist file to store guide data. At the moment there's no guide editor, "
																	@"but the file structure is fairly simple.\n\n"
																	@"If you use custom classes in your guide, you can store the class name "	
																	@"in the file and the loader will to the right thing. Most of the properties stored in the "
																	@"file will be set by KVC, so your classes can have arbitrary properties where needed.\n\nContinued..."
															 action:nil
													highlightedItem:nil];
	
	id <KNAppGuideStep> step7 = [KNAppGuideStep stepWithExplanation:@"To provide a way to link your guide files to your application, you need to "
																	@"supply a resolver when loading your file. When the guide loader encounters a key that also has "
																	@"<key>ShouldBeResolved set to YES, it will ask the resolver to return an object for the value of "
																	@"that key instead of using the key's value directly.\n\n"
																	@"The included resolver assumes the value in keys to be resolved are key paths, and simply returns "
								 									@"the value returned by giving the key path to a base class, which in this case is the window controller "
								 									@"for this window."
															 action:nil
													highlightedItem:nil];
	
	id <KNAppGuideStep> step8 = [KNAppGuideStep stepWithExplanation:@"You're done! Thank you for completing this guide, and I hope you like the "
																	@"KNAppGuide framework. For detailed documentation, see the documentation that "
																	@"accompanies the framework and the class headers. \n\nClick the ✔ button to finish."
															 action:nil
													highlightedItem:nil];
	
	
	[guide setSteps:[NSArray arrayWithObjects:step1, step2, step3, step4, step5, step6, step7, step8, nil]];
	
	presenter = [[KNAppGuideHUDPresenter alloc] initWithGuide:guide];
	[presenter setDelegate:self];
	[presenter beginPresentation];
}

#pragma mark -

-(IBAction)clickButton:(id)sender {
	[sender setTitle:@"Saved!"];
}
	
-(IBAction)clickToolbarItem:(id)sender {
	[sender setImage:[NSImage imageNamed:NSImageNameComputer]];
}

-(IBAction)chooseMenuItem:(id)sender {
	NSBeep();
}

@end
