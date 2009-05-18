//
//  KNAppGuideDelegate.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 18/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

@protocol KNAppGuideStep;
@protocol KNAppGuide;

@protocol KNAppGuideDelegate <NSObject>

-(void)guide:(id <KNAppGuide>)aGuide willMoveToStep:(id <KNAppGuideStep>)step;
-(void)guide:(id <KNAppGuide>)aGuide didMoveToStep:(id <KNAppGuideStep>)step;

@end
