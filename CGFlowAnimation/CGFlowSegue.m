//
//  CGFlowSegue.m
//  CGFlowAnimationDemo
//
//  Created by Chase Gorectke on 12/22/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import "CGFlowSegue.h"
#import "CGFlowAnimation.h"

@interface CGFlowSegue()
@property (nonatomic, assign) CGFloat duration;
@end

@implementation CGFlowSegue

-(id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
        self.dismiss = false;
        self.duration = 0.4;
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

@implementation CGFlowSegueFlipUp

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    [dst.view removeFromSuperview];
    
    [CGFlowAnimations flowFlipUpFromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window  initialFrame:src.view.frame andDuration:self.duration completion:^{
        
    }];
}

@end

@implementation CGFlowSegueFlipDown

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    [dst.view removeFromSuperview];
    
    [CGFlowAnimations flowFlipDownFromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window  initialFrame:src.view.frame andDuration:self.duration completion:^{
        
    }];
}

@end

@implementation CGFlowSegueSlideLeft

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    [dst.view removeFromSuperview];
    
    [CGFlowAnimations flowSlideLeftFromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window  initialFrame:src.view.frame andDuration:self.duration completion:^{
        if (!self.dismiss) {
            [src presentViewController:dst animated:NO completion:^{}];
        } else {
            [src dismissViewControllerAnimated:NO completion:^{}];
        }
    }];
}

@end

@implementation CGFlowSegueSlideRight

-(void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    [dst.view removeFromSuperview];
    
    [CGFlowAnimations flowSlideRightFromSource:src toDestination:dst withInContainer:[[UIApplication sharedApplication] delegate].window  initialFrame:src.view.frame andDuration:self.duration completion:^{
//        [[UIApplication sharedApplication] delegate].window.rootViewController = dst;
        if (!self.dismiss) {
            [src presentViewController:dst animated:NO completion:^{}];
        } else {
            [src dismissViewControllerAnimated:NO completion:^{}];
        }
    }];
}

@end

