//
//  KNAppGuideBasicKVOResolver.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 12/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideBasicKVCResolver.h"



@implementation KNAppGuideBasicKVCResolver

+(id <KNAppGuideResolver>)basicResolverWithBaseObject:(id)anObj {

	KNAppGuideBasicKVCResolver *resolver = [[KNAppGuideBasicKVCResolver alloc] init];
	[resolver setBaseObject:anObj];
	
	return [resolver autorelease];
	
}

@synthesize baseObject;

-(id)resolveValue:(NSString *)path forKey:(NSString *)key inClassNamed:(NSString *)className {

	// Here, we simply traverse through the key path starting at [self baseObject]. We don't care what the key or className is.
	
	NSArray *keys = [path componentsSeparatedByString:@"."];
	
	if ([keys count] == 0 || [path isEqualToString:@""]) {
		return [self baseObject];
	} else {
		
		id obj = [self baseObject];
		
		for (NSString *key in keys) {
			obj = [obj valueForKey:key];
			
			if ([obj isKindOfClass:[NSViewController class]]) {
				[obj view];
			}
		}
		
		return obj;
	}
}

-(void)dealloc {
	[self setBaseObject:nil];
	
	[super dealloc];
}

@end
