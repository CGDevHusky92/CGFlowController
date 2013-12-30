//
//  CGFlowSegue.m
//  CGFlowAnimationDemo
//
//  Created by Chase Gorectke on 12/22/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import "CGFlowSegue.h"
#import "CGFlowAnimation.h"

#define DEFAULT_DURATION    0.4

@interface CGFlowSegue()
@property (nonatomic, assign) CGFloat duration;
@end

@implementation CGFlowSegue

-(id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
        self.dismiss = false;
        self.duration = DEFAULT_DURATION;
    }
	return self;
}

-(void)perform {
    NSAssert(NO, @"Must Override Perform. Abstract Class.");
}

@end

@implementation CGFlowSegueNoAnimation

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    // match orientation/position
    dst.view.center = src.view.center;
    dst.view.transform = src.view.transform;
    dst.view.bounds = src.view.bounds;
    
    [dst.view removeFromSuperview];
    [[[UIApplication sharedApplication] delegate].window addSubview:dst.view];
    [[UIApplication sharedApplication] delegate].window.rootViewController = dst;
}

@end

@implementation CGFlowSegueSlideUp

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    [dst.view removeFromSuperview];
    
    completion aCompletion = ^{
        if (!self.dismiss) [src presentViewController:dst animated:NO completion:^{}];
        else [src dismissViewControllerAnimated:NO completion:^{}]; };
    
    kCGFlowAnimationType type = kCGFlowAnimationNone;
    if (src.interfaceOrientation == UIInterfaceOrientationPortrait) {
        type = (self.dismiss) ? kCGFlowAnimationSlideDown : kCGFlowAnimationSlideUp;
    } else if (src.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        type = (self.dismiss) ? kCGFlowAnimationSlideUp : kCGFlowAnimationSlideDown;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        type = (self.dismiss) ? kCGFlowAnimationSlideRight : kCGFlowAnimationSlideLeft;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        type = (self.dismiss) ? kCGFlowAnimationSlideLeft : kCGFlowAnimationSlideRight;
    }
    
    [CGFlowAnimations flowAnimation:type fromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window andDuration:self.duration completion:aCompletion];
}

@end

@implementation CGFlowSegueSlideDown

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    [dst.view removeFromSuperview];
    
    completion aCompletion = ^{
        if (!self.dismiss) [src presentViewController:dst animated:NO completion:^{}];
        else [src dismissViewControllerAnimated:NO completion:^{}]; };
    
    kCGFlowAnimationType type = kCGFlowAnimationNone;
    if (src.interfaceOrientation == UIInterfaceOrientationPortrait) {
        type = (self.dismiss) ? kCGFlowAnimationSlideUp : kCGFlowAnimationSlideDown;
    } else if (src.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        type = (self.dismiss) ? kCGFlowAnimationSlideDown : kCGFlowAnimationSlideUp;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        type = (self.dismiss) ? kCGFlowAnimationSlideLeft : kCGFlowAnimationSlideRight;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        type = (self.dismiss) ? kCGFlowAnimationSlideRight : kCGFlowAnimationSlideLeft;
    }
    
    [CGFlowAnimations flowAnimation:type fromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window andDuration:self.duration completion:aCompletion];
}

@end

@implementation CGFlowSegueSlideLeft

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    [dst.view removeFromSuperview];
    
    completion aCompletion = ^{
        if (!self.dismiss) [src presentViewController:dst animated:NO completion:^{}];
        else [src dismissViewControllerAnimated:NO completion:^{}]; };
    
    kCGFlowAnimationType type = kCGFlowAnimationNone;
    if (src.interfaceOrientation == UIInterfaceOrientationPortrait) {
        type = (self.dismiss) ? kCGFlowAnimationSlideRight : kCGFlowAnimationSlideLeft;
    } else if (src.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        type = (self.dismiss) ? kCGFlowAnimationSlideLeft : kCGFlowAnimationSlideRight;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        type = (self.dismiss) ? kCGFlowAnimationSlideUp : kCGFlowAnimationSlideDown;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        type = (self.dismiss) ? kCGFlowAnimationSlideDown : kCGFlowAnimationSlideUp;
    }
    
    [CGFlowAnimations flowAnimation:type fromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window andDuration:self.duration completion:aCompletion];
}

@end

@implementation CGFlowSegueSlideRight

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    completion aCompletion = ^{
        if (!self.dismiss) [src presentViewController:dst animated:NO completion:^{}];
        else [src dismissViewControllerAnimated:NO completion:^{}]; };
    
    kCGFlowAnimationType type = kCGFlowAnimationNone;
    if (src.interfaceOrientation == UIInterfaceOrientationPortrait) {
        type = (self.dismiss) ? kCGFlowAnimationSlideLeft : kCGFlowAnimationSlideRight;
    } else if (src.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        type = (self.dismiss) ? kCGFlowAnimationSlideRight : kCGFlowAnimationSlideLeft;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        type = (self.dismiss) ? kCGFlowAnimationSlideDown : kCGFlowAnimationSlideUp;
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        type = (self.dismiss) ? kCGFlowAnimationSlideUp : kCGFlowAnimationSlideDown;
    }
    
//    [dst willRotateToInterfaceOrientation:src.interfaceOrientation duration:0.0];
    [CGFlowAnimations flowAnimation:type fromSource:src toDestination:dst withInContainer:src.view.superview andDuration:self.duration completion:aCompletion];
}

@end

@implementation CGFlowSegueFlipUp

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    completion aCompletion = ^{
        if (!self.dismiss) [src presentViewController:dst animated:NO completion:^{}];
        else [src dismissViewControllerAnimated:NO completion:^{}]; };
    
    if (src.interfaceOrientation == UIInterfaceOrientationPortrait) {
        [CGFlowAnimations flowFlipUpFromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window andDuration:self.duration completion:aCompletion];
    } else if (src.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [CGFlowAnimations flowFlipDownFromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window andDuration:self.duration completion:aCompletion];
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
    }
}

@end

@implementation CGFlowSegueFlipDown

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    completion aCompletion = ^{
        if (!self.dismiss) [src presentViewController:dst animated:NO completion:^{}];
        else [src dismissViewControllerAnimated:NO completion:^{}]; };
    
    if (src.interfaceOrientation == UIInterfaceOrientationPortrait) {
        [CGFlowAnimations flowFlipDownFromSource:src toDestination:dst withInContainer:src.view.superview andDuration:self.duration completion:aCompletion];
    } else if (src.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [CGFlowAnimations flowFlipUpFromSource:src toDestination:dst withInContainer:src.view.superview andDuration:self.duration completion:aCompletion];
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
    } else if (src.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
    }
}

@end
