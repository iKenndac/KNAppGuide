//
//  KNAppGuideResolver.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 18/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol KNAppGuideResolver

-(id)resolveValue:(NSString *)path forKey:(NSString *)key inClassNamed:(NSString *)className;

//  ^ className will be nil if the sender is trying to resolve the class name.

@end