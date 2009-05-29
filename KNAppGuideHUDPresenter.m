//
//  KNAppGuideHUDPresenter.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 13/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideHUDPresenter.h"
#import "KNAppGuideStep.h"
#import "KNAppGuideClassicHighlight.h"
#import "NSWindow+Fade.h"
#import "KNAppGuideDelegate.h"
#import "KNAppGuide.h"

@interface KNAppGuideHUDPresenter (Private)

-(CGFloat)heightOfExplanationString:(NSString *)string inWidth:(CGFloat)width;

@end

@implementation KNAppGuideHUDPresenter

-(id)init {
	return [self initWithGuide:nil];
}

-(id)initWithGuide:(id <KNAppGuide>)g {
	
	if (!g) {
		// Insist on having a guide
		[self release];
		return nil;
	}
	
	if (self = [super initWithWindowNibName:@"KNAppGuideHUDPresenter"]) {
		
		NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
		NSString *appName = [[NSFileManager defaultManager] displayNameAtPath: bundlePath];
		
		[[self window] setTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"default window title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @""), appName]];
		
		[self willChangeValueForKey:@"guide"];
		guide = [g retain];
		[self didChangeValueForKey:@"guide"];
		
		[self sizeWindowToFit];
		
		[[self guide] setDelegate:self];
		[[self guide] reset];
	}
	return self;
}

-(void)dealloc {
	
	[guide release];
	guide = nil;
	
	if (currentControlHighlight) {
		
		NSDisableScreenUpdates();
		
		[currentControlHighlight fadeOutWithDuration:0.25];
		
		[[currentControlHighlight parentWindow] removeChildWindow:currentControlHighlight];
		[currentControlHighlight release];
		currentControlHighlight = nil;
		
		NSEnableScreenUpdates();
	}
	
	
	[super dealloc];
	
}

@synthesize guide;
@synthesize delegate;

-(void)showWindow:(id)sender {
	[self beginPresentation];
}

-(void)beginPresentation {
	[self retain];
	
	if ([[self delegate] respondsToSelector:@selector(presenter:willBeginPresentingGuide:)]) {
		[[self delegate] presenter:self willBeginPresentingGuide:[self guide]];
	}
	
	[[self window] fadeInWithDuration:0.25];
	
	if ([[self delegate] respondsToSelector:@selector(presenter:didBeginPresentingGuide:)]) {
		[[self delegate] presenter:self didBeginPresentingGuide:[self guide]];
	}
}

-(void)closePresentation {
	
	if ([[self delegate] respondsToSelector:@selector(presenter:willFinishPresentingGuide:completed:)]) {
		[[self delegate] presenter:self willFinishPresentingGuide:[self guide] completed:([[self guide] currentStep] == [[[self guide] steps] lastObject])];
	}
	
	[nextButton setTarget:nil];
	[nextButton setAction:nil];
	
	[[self window] fadeOutWithDuration:0.25];
	
	if ([[self delegate] respondsToSelector:@selector(presenter:didFinishPresentingGuide:completed:)]) {
		[[self delegate] presenter:self didFinishPresentingGuide:[self guide] completed:([[self guide] currentStep] == [[[self guide] steps] lastObject])];
	}
	
	[self release];
}


- (BOOL)windowShouldClose:(id)window {
	
	// If we return yes, the window gets closed immediately and we 
	// don't get a chance to fade it. Instead, return NO and fade ourselves.
	
	[self closePresentation];
	return NO;
}

-(IBAction)clickNext:(id)sender {
	
	if ([[self guide] hasFinished]) {
		[self closePresentation];
	} else {
		[[self guide] moveToNextStep];
	}
	
}

-(IBAction)clickPrevious:(id)sender {
	if (![[self guide] isAtBeginning]) {
		[[self guide] moveToPreviousStep];
	}
}

-(IBAction)clickPerformAction:(id)sender {
	[[[self guide] currentStep] performAction];
}


#pragma mark -
#pragma mark UI Labels and such

-(NSString *)showMeButtonTitle {
	return NSLocalizedStringFromTableInBundle(@"show me button title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @"");
}

+(NSSet *)keyPathsForValuesAffectingNextButtonTitle {
	return [NSSet setWithObjects:@"guide.hasFinished", nil];
}

-(NSString *)nextButtonTitle {
	if ([[self guide] hasFinished]) {
		return NSLocalizedStringFromTableInBundle(@"done button title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @"");
	} else {
		return NSLocalizedStringFromTableInBundle(@"next button title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @"");
	}
}

-(NSString *)previousButtonTitle {
	return NSLocalizedStringFromTableInBundle(@"previous button title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @"");
}

+(NSSet *)keyPathsForValuesAffectingGuideProgressTitle {
	return [NSSet setWithObjects:@"guide", @"guide.currentStep", nil];
}

-(NSString *)guideProgressTitle {
	return [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"progress label", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @""), 
			[[[self guide] steps] indexOfObject:[[self guide] currentStep]] + 1,
			[[[self guide] steps] count]];
}

#pragma mark -
#pragma mark Tags

+(NSSet *)keyPathsForValuesAffectingTaggedStepExplanation {
	return [NSSet setWithObjects:@"guide", @"guide.currentStep", nil];
}

-(NSString *)taggedStepExplanation {
	
	NSString *str = [[[[self guide] currentStep] explanation] stringByReplacingOccurrencesOfString:@"%PREVIOUSBUTTONTITLE" 
																						withString:NSLocalizedStringFromTableInBundle(@"previous button title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @"")];
	
	str = [str stringByReplacingOccurrencesOfString:@"%NEXTBUTTONTITLE"
										 withString:NSLocalizedStringFromTableInBundle(@"next button title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @"")];
	
	str = [str stringByReplacingOccurrencesOfString:@"%DONEBUTTONTITLE"
										 withString:NSLocalizedStringFromTableInBundle(@"done button title", @"KNAppGuideHUDPresenter", [NSBundle bundleForClass:[self class]], @"")];
	
	
	if ([[self delegate] respondsToSelector:@selector(presenter:willDisplayExplanation:forStep:inGuide:)]) {
		str = [[self delegate] presenter:self willDisplayExplanation:str forStep:[[self guide] currentStep] inGuide:[self guide]];
	}
	
	return str;
}

#pragma mark -
#pragma mark Window sizing

-(void)sizeWindowToFit {

	// In System 7 and 8, the guide window resizes to fit each step as it's displayed.
	// However, this (IMO) gives bad UX as if we resize from the top, the buttons
	// move out from under the mouse, and if we resize from the bottom the titlebar 
	// moves all over the place. To get around this, we'll set the window size to fit the largest 
	// step and leave it there.
	
	CGFloat windowHeightNotIncludingExplanationText = [[self window] frame].size.height - [stepExplanationTextField frame].size.height;
	CGFloat largestExplanationHeight = 0.0;
	
	for (id <KNAppGuideStep> step in [[self guide] steps]) {
		
		CGFloat explanationHeight = [self heightOfExplanationString:[step explanation] 
															inWidth:[stepExplanationTextField frame].size.width];
	
		if (explanationHeight > largestExplanationHeight) {
			largestExplanationHeight = explanationHeight;
		}
	}
	
	NSRect windowFrame = [[self window] frame];
	windowFrame.size.height = windowHeightNotIncludingExplanationText + largestExplanationHeight;
	
	[[self window] setFrame:windowFrame display:YES];
	
}

-(CGFloat)heightOfExplanationString:(NSString *)string inWidth:(CGFloat)width {
	
	if (!string) {
		return 0.0;
	}
	
	NSDictionary *attributes = [[stepExplanationTextField attributedStringValue] attributesAtIndex:0 effectiveRange:NULL];
	
	NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:[[[NSAttributedString alloc] initWithString:string attributes:attributes] autorelease]];
	NSTextContainer *container = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(width, FLT_MAX)];
	NSLayoutManager *manager = [[NSLayoutManager alloc] init];
	
	[container setLineFragmentPadding:0.0];
	
	[manager addTextContainer:container];
	[storage addLayoutManager:manager];
	
	[manager glyphRangeForTextContainer:container];
	
	CGFloat height = [manager usedRectForTextContainer:container].size.height;
	
	[storage release];
	[container release];
	[manager release];
	
	return height;
}

#pragma mark -
#pragma mark KNAppGuideDelegate

-(void)guide:(id <KNAppGuide>)aGuide willMoveToStep:(id <KNAppGuideStep>)step {
	
	// Remove the existing highlight, if any
	
	if (aGuide == [self guide]) {
		// ^ Well, you never know!
		
		if ([[self delegate] respondsToSelector:@selector(presenter:willMoveToStep:inGuide:)]) {
			[[self delegate] presenter:self willMoveToStep:step inGuide:[self guide]];
		}
		
		if (currentControlHighlight) {
			
			NSDisableScreenUpdates();
			
			[currentControlHighlight fadeOutWithDuration:0.25];
			
			[[currentControlHighlight parentWindow] removeChildWindow:currentControlHighlight];
			[currentControlHighlight release];
			currentControlHighlight = nil;
			
			NSEnableScreenUpdates();
		}
	}	
}

-(void)guide:(id <KNAppGuide>)aGuide didMoveToStep:(id <KNAppGuideStep>)step {
	
	// Add the new highlight, if possible
	
	if ([step highlightedItem]) {
		
		currentControlHighlight = [[KNAppGuideClassicHighlight highlightForItem:[step highlightedItem]] retain];
	}
	
	if ([[self delegate] respondsToSelector:@selector(presenter:didMoveToStep:inGuide:)]) {
		[[self delegate] presenter:self didMoveToStep:step inGuide:[self guide]];
	}
}

-(void)guide:(id <KNAppGuide>)aGuide action:(id <KNAppGuideAction>)anAction wasPerformedForStep:(id <KNAppGuideStep>)step {
	
	if (aGuide == [self guide]) {
		// ^ Well, you never know!

		if (step == [[[self guide] steps] lastObject] && step == [[self guide] currentStep]) {
			[self closePresentation];
		}
	}
}

@end
