//
//  CGFlowAnimations.m
//
//  Created by Charles Gorectke on 1/7/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import "CGFlowController.h"

@interface CGFlowAnimations ()

+ (void)flowModalSlideUp:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete;
+ (void)flowModalSlideDown:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete;
+ (void)flowModalSlideLeft:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete;
+ (void)flowModalSlideRight:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete;

+ (void)flowModalDismissCenterDisappear:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowModalDismissDisappearAtPoint:(CGPoint)point withSrc:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;

+ (void)flowPanelSlideLeft:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowPanelSlideRight:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;

+ (void)flowPanelDismiss:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;

+ (void)flowSlideUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowSlideDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowSlideLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowSlideRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;

+ (void)flowFlipUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowFlipDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowFlipLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;
+ (void)flowFlipRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete;

+ (CGFlowAnimationType)correctForOrientation:(UIInterfaceOrientation)orientation withAnimation:(CGFlowAnimationType)animation;

@end

@implementation CGFlowAnimations

+ (void)flowAnimation:(CGFlowAnimationType)animationType fromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration interactively:(BOOL)interactive withScale:(CGPoint)scale completion:(Completion)complete
{
    CGFlowAnimationType correctedType;
    if (interactive && ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        correctedType = animationType;
    } else {
        correctedType = [self correctForOrientation:srcController.interfaceOrientation withAnimation:animationType];
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
    } else if (correctedType == kCGFlowModalPresentSlideUp) {
        [self flowModalSlideUp:srcController toDestination:destController withContainer:containerView andDuration:duration andScale:scale completion:complete];
    } else if (correctedType == kCGFlowModalPresentSlideDown) {
        [self flowModalSlideDown:srcController toDestination:destController withContainer:containerView andDuration:duration andScale:scale completion:complete];
    } else if (correctedType == kCGFlowModalPresentSlideLeft) {
        [self flowModalSlideLeft:srcController toDestination:destController withContainer:containerView andDuration:duration andScale:scale completion:complete];
    } else if (correctedType == kCGFlowModalPresentSlideRight) {
        [self flowModalSlideRight:srcController toDestination:destController withContainer:containerView andDuration:duration andScale:scale completion:complete];
    } else if (correctedType == kCGFlowModalDismissDisappearCenter) {
        [self flowModalDismissCenterDisappear:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowModalDismissDisappearPoint) {
        [self flowModalDismissDisappearAtPoint:scale withSrc:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowModalPanelSlideLeft) {
        [self flowPanelSlideLeft:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowModalPanelSlideRight) {
        [self flowPanelSlideRight:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    } else if (correctedType == kCGFlowModalPanelReturn) {
        [self flowPanelDismiss:srcController toDestination:destController withContainer:containerView andDuration:duration completion:complete];
    }
}

+ (void)flowModalSlideUp:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    
    // Round the corners
    if (scale.x != 1.0 && scale.y != 1.0) {
        toView.layer.cornerRadius = 8;
        toView.layer.masksToBounds = YES;
    }
    
    // Point to rect percentage determination using scale
    // 0.9, 0.35 CGRectMake(15, 184, 290, 200);
    CGRect bounds = containerView.bounds;
    CGFloat width = (scale.x * bounds.size.width);
    CGFloat height = (scale.y * bounds.size.height);
    CGFloat x = (bounds.size.width - width) / 2;
    CGFloat y = (bounds.size.height - height) / 2;
    CGRect toFrame = CGRectMake(x, y, width, height);
    
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(toFrame, 0, bounds.size.height)];
    [containerView addSubview:toView];
    
    // Scale up to 90%
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = toFrame;
        if (scale.x != 1.0 && scale.y != 1.0) {
            fromView.alpha = 0.5;
        }
    } completion:complete];
}

+ (void)flowModalSlideDown:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    
    // Round the corners
    toView.layer.cornerRadius = 8;
    toView.layer.masksToBounds = YES;
    
    // Point to rect percentage determination using scale
    // 0.9, 0.35 CGRectMake(15, 184, 290, 200);
    CGRect bounds = containerView.bounds;
    CGFloat width = (scale.x * bounds.size.width);
    CGFloat height = (scale.y * bounds.size.height);
    CGFloat x = (bounds.size.width - width) / 2;
    CGFloat y = (bounds.size.height - height) / 2;
    CGRect toFrame = CGRectMake(x, y, width, height);
    
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(toFrame, 0, -bounds.size.height)];
    [containerView addSubview:toView];
    
    // Scale up to 90%
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = toFrame;
        fromView.alpha = 0.5;
    } completion:complete];
}

+ (void)flowModalSlideLeft:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    
    // Round the corners
    toView.layer.cornerRadius = 8;
    toView.layer.masksToBounds = YES;
    
    // Point to rect percentage determination using scale
    // 0.9, 0.35 CGRectMake(15, 184, 290, 200);
    CGRect bounds = containerView.bounds;
    CGFloat width = (scale.x * bounds.size.width);
    CGFloat height = (scale.y * bounds.size.height);
    CGFloat x = (bounds.size.width - width) / 2;
    CGFloat y = (bounds.size.height - height) / 2;
    CGRect toFrame = CGRectMake(x, y, width, height);
    
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(toFrame, bounds.size.width, 0)];
    [containerView addSubview:toView];
    
    // Scale up to 90%
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = toFrame;
        fromView.alpha = 0.5;
    } completion:complete];
}

+ (void)flowModalSlideRight:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration andScale:(CGPoint)scale completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    
    // Round the corners
    toView.layer.cornerRadius = 8;
    toView.layer.masksToBounds = YES;
    
    // Point to rect percentage determination using scale
    // 0.9, 0.35 CGRectMake(15, 184, 290, 200);
    CGRect bounds = containerView.bounds;
    CGFloat width = (scale.x * bounds.size.width);
    CGFloat height = (scale.y * bounds.size.height);
    CGFloat x = (bounds.size.width - width) / 2;
    CGFloat y = (bounds.size.height - height) / 2;
    CGRect toFrame = CGRectMake(x, y, width, height);
    
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(toFrame, -bounds.size.width, 0)];
    [containerView addSubview:toView];
    
    // Scale up to 90%
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = toFrame;
        fromView.alpha = 0.5;
    } completion:complete];
}

+ (void)flowModalDismissCenterDisappear:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    [UIView animateWithDuration:duration animations: ^{
        fromView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        toView.alpha = 1.0;
    } completion:complete];
}

+ (void)flowModalDismissDisappearAtPoint:(CGPoint)point withSrc:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    [UIView animateWithDuration:duration animations: ^{
        [fromView setCenter:point];
        fromView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        toView.alpha = 1.0;
    } completion:complete];
}

+ (void)flowPanelSlideLeft:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:bounds];
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = bounds;
        fromView.frame = CGRectOffset(bounds, -(bounds.size.width * 0.8), 0);
        fromView.alpha = 0.5;
    } completion:complete];
}

+ (void)flowPanelSlideRight:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    UIView *fromView = srcController.view;
    UIView *toView = destController.view;
    
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:bounds];
    [containerView addSubview:toView];
    [containerView bringSubviewToFront:fromView];
    
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = bounds;
        fromView.frame = CGRectOffset(bounds, (bounds.size.width * 0.8), 0);
    } completion:complete];
}

+ (void)flowPanelDismiss:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    UIView *toView = destController.view;
    CGRect bounds = containerView.bounds;
    [UIView animateWithDuration:duration animations: ^{
        toView.frame = bounds;
    } completion:complete];
}

+ (void)flowSlideUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, 0, bounds.size.height)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [srcController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, 0, -bounds.size.height)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+ (void)flowSlideDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, 0, -bounds.size.height)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [srcController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, 0, bounds.size.height)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+ (void)flowSlideLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, bounds.size.width, 0)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [destController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, -bounds.size.width, 0)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+ (void)flowSlideRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
    CGRect bounds = containerView.bounds;
    srcController.view.frame = bounds;
    [destController.view setFrame:CGRectOffset(bounds, -bounds.size.width, 0)];
    [UIView animateKeyframesWithDuration:duration delay:0.0f options:0 animations:^{
        [destController setNeedsStatusBarAppearanceUpdate];
        [srcController.view setFrame:CGRectOffset(bounds, bounds.size.width, 0)];
        [destController.view setFrame:bounds];
    } completion:complete];
}

+ (void)flowFlipUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
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

+ (void)flowFlipDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
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

+ (void)flowFlipLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
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

+ (void)flowFlipRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration completion:(Completion)complete
{
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

+ (CGFlowAnimationType)correctForOrientation:(UIInterfaceOrientation)orientation withAnimation:(CGFlowAnimationType)animation
{
    if (animation == kCGFlowModalPresent || animation == kCGFlowModalDismiss) {
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
