//
//  KNAppGuideBasicKVOResolver.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 12/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNAppGuide/KNAppGuideResolver.h>

/*
 
 This is a basic resolver class that uses KVC from -baseObject to resolve values. 
 
 */

@interface KNAppGuideBasicKVCResolver : NSObject <KNAppGuideResolver> {

	id baseObject;
}

+(id <KNAppGuideResolver>)basicResolverWithBaseObject:(id)anObj;

@property (retain, readwrite, nonatomic) id baseObject;

@end
