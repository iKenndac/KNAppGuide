//
//  KNAppGuideDelegate.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 18/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

@protocol KNAppGuideStep;
@protocol KNAppGuide;
@protocol KNAppGuideAction;

@protocol KNAppGuideDelegate <NSObject>

@optional

-(void)guide:(id <KNAppGuide>)aGuide willMoveToStep:(id <KNAppGuideStep>)step;
-(void)guide:(id <KNAppGuide>)aGuide didMoveToStep:(id <KNAppGuideStep>)step;
-(void)guide:(id <KNAppGuide>)aGuide action:(id <KNAppGuideAction>)anAction wasPerformedForStep:(id <KNAppGuideStep>)step;

@end
