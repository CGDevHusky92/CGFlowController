//
//  CGFlowAnimations.m
//
//  Created by Charles Gorectke on 1/7/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import "CGFlowController.h"

@interface CGFlowAnimations()

+(void)flowModalSlideUp:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration isAppearence:(BOOL)appearing andScale:(CGPoint)scale completion:(Completion)complete;

+(void)flowSlideUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+(void)flowSlideDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+(void)flowSlideLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+(void)flowSlideRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;

+(void)flowFlipUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+(void)flowFlipDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+(void)flowFlipLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+(void)flowFlipRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;

+(kCGFlowAnimationType)correctForOrientation:(UIInterfaceOrientation)orientation withAnimation:(kCGFlowAnimationType)animation;

@end

@implementation CGFlowAnimations

+(void)flowAnimation:(kCGFlowAnimationType)animationType fromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration withOrientation:(UIInterfaceOrientation)orientation interactively:(BOOL)interactive completion:(Completion)complete {
    kCGFlowAnimationType correctedType;
    if (interactive && ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        correctedType = animationType;
    } else {
        correctedType = [self correctForOrientation:orientation withAnimation:animationType];
    }
    
    if (correctedType == kCGFlowAnimationSlideUp) {
        [self flowSlideUpFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationSlideDown) {
        [self flowSlideDownFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationSlideLeft) {
        [self flowSlideLeftFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationSlideRight) {
        [self flowSlideRightFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationFlipUp) {
        [self flowFlipUpFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationFlipDown) {
        [self flowFlipDownFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationFlipLeft) {
        [self flowFlipLeftFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationFlipRight) {
        [self flowFlipRightFromSource:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowAnimationModalPresent) {
        [self flowModalSlideUp:srcController toDestination:destController withContainer:containerView andDuration:duration isAppearence:YES andScale:CGPointMake(0, 0) completion:complete];
    } else if (correctedType == kCGFlowAnimationModalDismiss) {
        [self flowModalSlideUp:srcController toDestination:destController withContainer:containerView andDuration:duration isAppearence:NO andScale:CGPointMake(0, 0) completion:complete];
    }
}

+(void)flowModalSlideUp:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration isAppearence:(BOOL)appearing andScale:(CGPoint)scale completion:(Completion)complete {
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    
    // Presenting
    if (appearing) {
        // Round the corners
        toView.layer.cornerRadius = 8;
        toView.layer.masksToBounds = YES;
        // Point to rect percentage determination using scale
        CGRect toFrame = CGRectMake(15, 184, 290, 200);
        
        CGRect bounds = containerView.bounds;
        srcController.view.frame = bounds;
        [destController.view setFrame:CGRectOffset(toFrame, 0, bounds.size.height)];
        [containerView addSubview:toView];
        
        // Scale up to 90%
        [UIView animateWithDuration:duration animations: ^{
            toView.frame = toFrame;
            fromView.alpha = 0.5;
        } completion:complete];
    } else {
        [UIView animateWithDuration:duration animations: ^{
            fromView.transform = CGAffineTransformMakeScale(0.0, 0.0);
            toView.alpha = 1.0;
        } completion:complete];
    }
}

+(void)flowSlideUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, 0, bounds.size.height)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [srcController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, 0, -bounds.size.height)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+(void)flowSlideDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, 0, -bounds.size.height)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [srcController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, 0, bounds.size.height)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+(void)flowSlideLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, bounds.size.width, 0)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [destController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, -bounds.size.width, 0)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+(void)flowSlideRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, -bounds.size.width, 0)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [destController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, bounds.size.width, 0)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+(void)flowFlipUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    // Start building the transform - 3D so need perspective
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / CGRectGetHeight(bounds);
    containerView.layer.sublayerTransform = transform;
    destController.view.layer.transform = CATransform3DMakeRotation(-1.0 * M_PI_2, 1, 0, 0);
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:0 animations:^{
        // First half is rotating in
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            srcController.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            destController.view.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
        }];
    } completion:complete];
}

+(void)flowFlipDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    // Start building the transform - 3D so need perspective
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / CGRectGetHeight(bounds);
    containerView.layer.sublayerTransform = transform;
    destController.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:0 animations:^{
        // First half is rotating in
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            srcController.view.layer.transform = CATransform3DMakeRotation(-1.0 * M_PI_2, 1, 0, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            destController.view.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
        }];
    } completion:complete];
}

+(void)flowFlipLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    // Start building the transform - 3D so need perspective
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / CGRectGetWidth(bounds);
    containerView.layer.sublayerTransform = transform;
    destController.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:0 animations:^{
        // First half is rotating in
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            srcController.view.layer.transform = CATransform3DMakeRotation(-1.0 * M_PI_2, 0, 1, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            destController.view.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        }];
    } completion:complete];
}

+(void)flowFlipRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete {
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    // Start building the transform - 3D so need perspective
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / CGRectGetWidth(bounds);
    containerView.layer.sublayerTransform = transform;
    destController.view.layer.transform = CATransform3DMakeRotation(-1.0 * M_PI_2, 0, 1, 0);
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:0 animations:^{
        // First half is rotating in
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            srcController.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            destController.view.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        }];
    } completion:complete];
}

+(kCGFlowAnimationType)correctForOrientation:(UIInterfaceOrientation)orientation withAnimation:(kCGFlowAnimationType)animation {
    if (animation == kCGFlowAnimationModalPresent || animation == kCGFlowAnimationModalDismiss) {
        return animation;
    }
    
    if (UIInterfaceOrientationPortrait == orientation) {
        return animation;
    } else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
        if (animation == kCGFlowAnimationSlideUp) {
            return kCGFlowAnimationSlideDown;
        } else if (animation == kCGFlowAnimationSlideDown) {
            return kCGFlowAnimationSlideUp;
        } else if (animation == kCGFlowAnimationSlideLeft) {
            return kCGFlowAnimationSlideRight;
        } else if (animation == kCGFlowAnimationSlideRight) {
            return kCGFlowAnimationSlideLeft;
        } else if (animation == kCGFlowAnimationFlipUp) {
            return kCGFlowAnimationFlipDown;
        } else if (animation == kCGFlowAnimationFlipDown) {
            return kCGFlowAnimationFlipUp;
        } else if (animation == kCGFlowAnimationFlipLeft) {
            return kCGFlowAnimationFlipRight;
        } else if (animation == kCGFlowAnimationFlipRight) {
            return kCGFlowAnimationFlipLeft;
        } else {
            return kCGFlowAnimationNone;
        }
    } else if (UIInterfaceOrientationLandscapeLeft == orientation) {
        if (animation == kCGFlowAnimationSlideUp) {
            return kCGFlowAnimationSlideLeft;
        } else if (animation == kCGFlowAnimationSlideDown) {
            return kCGFlowAnimationSlideRight;
        } else if (animation == kCGFlowAnimationSlideLeft) {
            return kCGFlowAnimationSlideDown;
        } else if (animation == kCGFlowAnimationSlideRight) {
            return kCGFlowAnimationSlideUp;
        } else if (animation == kCGFlowAnimationFlipUp) {
            return kCGFlowAnimationFlipLeft;
        } else if (animation == kCGFlowAnimationFlipDown) {
            return kCGFlowAnimationFlipRight;
        } else if (animation == kCGFlowAnimationFlipLeft) {
            return kCGFlowAnimationFlipDown;
        } else if (animation == kCGFlowAnimationFlipRight) {
            return kCGFlowAnimationFlipUp;
        } else {
            return kCGFlowAnimationNone;
        }
    } else if (UIInterfaceOrientationLandscapeRight == orientation) {
        if (animation == kCGFlowAnimationSlideUp) {
            return kCGFlowAnimationSlideRight;
        } else if (animation == kCGFlowAnimationSlideDown) {
            return kCGFlowAnimationSlideLeft;
        } else if (animation == kCGFlowAnimationSlideLeft) {
            return kCGFlowAnimationSlideUp;
        } else if (animation == kCGFlowAnimationSlideRight) {
            return kCGFlowAnimationSlideDown;
        } else if (animation == kCGFlowAnimationFlipUp) {
            return kCGFlowAnimationFlipRight;
        } else if (animation == kCGFlowAnimationFlipDown) {
            return kCGFlowAnimationFlipLeft;
        } else if (animation == kCGFlowAnimationFlipLeft) {
            return kCGFlowAnimationFlipUp;
        } else if (animation == kCGFlowAnimationFlipRight) {
            return kCGFlowAnimationFlipDown;
        } else {
            return kCGFlowAnimationNone;
        }
    }
    return kCGFlowAnimationNone;
}

@end
