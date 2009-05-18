//
//  KNAppGuideLoader.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 12/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
 
 This class loads guides from plist files. See the sample guide included with this project for an 
 example of their structure - it's quite simple.
 
 To allow the guide to integrate with your application, the loader needs a "resolver" object. The resolver
 is an object that convert the value stored in the guide file to an object in your application. Any key that also has 
 <key>ShouldBeResolved set to YES will be resolved instead of used directly. 
 
 For example: 
 
 step {
	highlightedView = window.contentView;
	highlightedViewShouldBeResolved = YES;
 }
 
 When the loader encounters this, it will ask the resolver for the value represented by window.contentView. If you're using the 
 built-in KVC resolver, it'll ask the base object for the value at window.contentView. I personally set the resolver's base class to my 
 window's NSWindowController instance so I can easily find controls to hightlight.
 
 We're actually quite smart with loading properties. All values found are set using the given resolver and 
 KVC (except a few special cases) so you can include the properties needed for your custom classes. 
 
 To use a custom class instead of the built-in ones, set the objectClass key in the guide, step or action to the name of your custom class. i.e.:
 
 guide {
	title = "How do I click a button?";
	objectClass = "MyCoolGuideSubclass";
	steps = {	
		...
	}
 }
 
 Note: Actions require an objectClass key since there's no "default" action class.
 
 The special cases that don't use KVC or the resolver are:
 
 - A guide's steps. These must be in an array for the key "steps" in the guide dictionary. 
 - A step's action. This must be in a dictionary for the key "action" in the step dictionary.
 
 Obviously, objectClass won't use KVC since we need it before the object is instantiated but it will be resolved if needed.
 
 */

@protocol KNAppGuideResolver;
@protocol KNAppGuide;

@interface KNAppGuideLoader : NSObject {
	id <KNAppGuideResolver> resolver;
}

+(id <KNAppGuide>)guideFromFile:(NSString *)guidePath resolver:(id <KNAppGuideResolver>)aResolver; // Loads from the file at path
+(id <KNAppGuide>)guideFromBundle:(NSBundle *)bundle withName:(NSString *)name resolver:(id <KNAppGuideResolver>)aResolver; // Will search for <name>.guide, then just <name> in the given bundle.
+(id <KNAppGuide>)guideWithName:(NSString *)name resolver:(id <KNAppGuideResolver>)aResolver; // Will search for <name>.guide, then just <name> in the main bundle.

@property (readwrite, nonatomic, retain) id <KNAppGuideResolver> resolver;

@end
