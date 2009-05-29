//
//  KNAppGuidePresenter.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol KNAppGuide;
@protocol KNAppGuideStep;
@protocol KNAppGuidePresenterDelegate;

@protocol KNAppGuidePresenter

-(id)initWithGuide:(id <KNAppGuide>)g;

@property (nonatomic, readonly) id <KNAppGuide> guide;
@property (nonatomic, readwrite, retain) id <KNAppGuidePresenterDelegate> delegate;

-(NSWindow *)window;

-(void)beginPresentation;
-(void)closePresentation;

@end

@protocol KNAppGuidePresenterDelegate <NSObject>

@optional

-(void)presenter:(id <KNAppGuidePresenter>)aPresenter willBeginPresentingGuide:(id <KNAppGuide>)aGuide; // Called before the window is shown
-(void)presenter:(id <KNAppGuidePresenter>)aPresenter didBeginPresentingGuide:(id <KNAppGuide>)aGuide; // Called after the window is shown

-(void)presenter:(id <KNAppGuidePresenter>)aPresenter willMoveToStep:(id <KNAppGuideStep>)aStep inGuide:(id <KNAppGuide>)aGuide;
-(void)presenter:(id <KNAppGuidePresenter>)aPresenter didMoveToStep:(id <KNAppGuideStep>)aStep inGuide:(id <KNAppGuide>)aGuide;

-(void)presenter:(id <KNAppGuidePresenter>)aPresenter willFinishPresentingGuide:(id <KNAppGuide>)aGuide completed:(BOOL)wasCompleted; // Called before the window is closed
-(void)presenter:(id <KNAppGuidePresenter>)aPresenter didFinishPresentingGuide:(id <KNAppGuide>)aGuide completed:(BOOL)wasCompleted; // Called after the window is closed

-(NSString *)presenter:(id <KNAppGuidePresenter>)aPresenter willDisplayExplanation:(NSString *)anExplanation forStep:(id <KNAppGuideStep>)aStep inGuide:(id <KNAppGuide>)aGuide;

@end
