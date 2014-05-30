/**
 *  CGFlowAnimations.m
 *  CGFlowController
 *
 *  Created by Charles Gorectke on 11/25/13.
 *  Copyright (c) 2014 Revision Works, LLC. All rights reserved.
 *
 *  The MIT License (MIT)
 *
 *  Copyright (c) 2014 Revision Works, LLC
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 *
 *  Last updated on 5/29/14
 */

#import <QuartzCore/QuartzCore.h>
#import "CGFlowController.h"

@interface CGFlowAnimations ()

+ (void)flowModalSlideUp:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowModalSlideDown:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowModalSlideLeft:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowModalSlideRight:(CGFlowObject *)flowObj completion:(Completion)complete;

+ (void)flowModalDismissCenterDisappear:(CGFlowObject *)flowObj completion:(Completion)complete;
//+ (void)flowModalDismissDisappearAtPoint:(CGPoint)point completion:(Completion)complete;

+ (void)flowPanelSlideLeft:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowPanelSlideRight:(CGFlowObject *)flowObj completion:(Completion)complete;

+ (void)flowPanelDismissLeft:(CGFlowObject *)flowObj  completion:(Completion)complete;
+ (void)flowPanelDismissRight:(CGFlowObject *)flowObj  completion:(Completion)complete;

+ (void)flowSlideUpFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowSlideDownFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowSlideLeftFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowSlideRightFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;

+ (void)flowFlipUpFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowFlipDownFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowFlipLeftFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;
+ (void)flowFlipRightFromSource:(CGFlowObject *)flowObj completion:(Completion)complete;

+ (CGFlowAnimationType)correctForOrientation:(UIInterfaceOrientation)orientation withAnimation:(CGFlowAnimationType)animation;

@end

@implementation CGFlowAnimations

+ (void)flowAnimationWithObject:(CGFlowObject *)flowObj withCompletion:(void(^)(BOOL))complete
{
    CGFlowAnimationType correctedType;
    if (flowObj.interactive && ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        correctedType = flowObj.animationType;
    } else {
        correctedType = [self correctForOrientation:flowObj.source.viewController.interfaceOrientation withAnimation:flowObj.animationType];
    }
    
    CGFlowAnimationCategory cat = [self animationCategoryForType:flowObj.animationType];
    switch (cat) {
        case kCGFlowCategory2DAnimation: {
            flowObj.source.eliminate = true;
            if (correctedType == kCGFlowAnimationSlideUp) {
                [self flowSlideUpFromSource:flowObj completion:complete];
            } else if (correctedType == kCGFlowAnimationSlideDown) {
                [self flowSlideDownFromSource:flowObj completion:complete];
            } else if (correctedType == kCGFlowAnimationSlideLeft) {
                [self flowSlideLeftFromSource:flowObj completion:complete];
            } else if (correctedType == kCGFlowAnimationSlideRight) {
                [self flowSlideRightFromSource:flowObj completion:complete];
            }
            break;
        }
        case kCGFlowCategory3DAnimation: {
            flowObj.source.eliminate = true;
            if (correctedType == kCGFlowAnimationFlipUp) {
                [self flowFlipUpFromSource:flowObj completion:complete];
            } else if (correctedType == kCGFlowAnimationFlipDown) {
                [self flowFlipDownFromSource:flowObj completion:complete];
            } else if (correctedType == kCGFlowAnimationFlipLeft) {
                [self flowFlipLeftFromSource:flowObj completion:complete];
            } else if (correctedType == kCGFlowAnimationFlipRight) {
                [self flowFlipRightFromSource:flowObj completion:complete];
            }
            break;
        }
        case kCGFlowCategoryModalPresent: {
            if (correctedType == kCGFlowModalPresentSlideUp) {
                [self flowModalSlideUp:flowObj completion:complete];
            } else if (correctedType == kCGFlowModalPresentSlideDown) {
                [self flowModalSlideDown:flowObj completion:complete];
            } else if (correctedType == kCGFlowModalPresentSlideLeft) {
                [self flowModalSlideLeft:flowObj completion:complete];
            } else if (correctedType == kCGFlowModalPresentSlideRight) {
                [self flowModalSlideRight:flowObj completion:complete];
            }
            break;
        }
        case kCGFlowCategoryModalDismiss: {
            flowObj.source.eliminate = true;
            if (correctedType == kCGFlowModalDismissDisappearCenter) {
                [self flowModalDismissCenterDisappear:flowObj completion:complete];
            } else if (correctedType == kCGFlowModalDismissDisappearPoint) {
//                [self flowModalDismissDisappearAtPoint:flowObj.destination.size completion:complete];
            }
            break;
        }
        case kCGFlowCategoryPanelPresent: {
            if (correctedType == kCGFlowPanelSlideLeft) {
                [self flowPanelSlideLeft:flowObj completion:complete];
            } else if (correctedType == kCGFlowPanelSlideRight) {
                [self flowPanelSlideRight:flowObj completion:complete];
            }
            break;
        }
        case kCGFlowCategoryPanelDismiss: {
            if (correctedType == kCGFlowPanelLeftReturn) {
                [self flowPanelDismissLeft:flowObj completion:complete];
            } else if (correctedType == kCGFlowPanelRightReturn) {
                [self flowPanelDismissRight:flowObj completion:complete];
            }
            break;
        }
        default:
            NSLog(@"Error: Unknown Animation Type");
            break;
    }
}

+ (void)genericAnimationWithFlow:(CGFlowObject *)flow andCompletion:(void(^)(BOOL))complete
{
    UIView *fromView = flow.source.viewController.view;
    UIView *toView = flow.destination.viewController.view;
    UIView *container = flow.containerView;
    [toView setFrame:flow.destination.startPosition];
    
    CGFlowAnimationCategory cat = [self animationCategoryForType:flow.animationType];
    switch (cat) {
        case kCGFlowCategory2DAnimation: {
            [fromView setFrame:flow.source.startPosition];
            [flow.containerView addSubview:toView];
            
            [UIView animateWithDuration:flow.duration animations: ^{
                [flow.source.viewController setNeedsStatusBarAppearanceUpdate];
                [fromView setFrame:flow.source.endPosition];
                [toView setFrame:container.bounds];
            } completion:complete];
            break;
        }
        case kCGFlowCategory3DAnimation: {
            [fromView setFrame:flow.source.startPosition];
            [flow.containerView addSubview:toView];
            
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1 / CGRectGetHeight(container.bounds);
            container.layer.sublayerTransform = transform;
            toView.layer.transform = flow.destination.preAnimationTransform;
            [UIView animateKeyframesWithDuration:flow.duration delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
                [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                    fromView.layer.transform = flow.source.stageOneTransform;
                }];
                [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                    toView.layer.transform = flow.destination.stageTwoTransform;
                }];
            } completion:complete];
            break;
        }
        case kCGFlowCategoryModalPresent: {
            [fromView setFrame:flow.source.startPosition];
            toView.layer.cornerRadius = 8;
            toView.layer.masksToBounds = YES;
            [flow.containerView addSubview:toView];
            [UIView animateWithDuration:flow.duration animations: ^{
                toView.frame = flow.destination.endPosition;
                fromView.alpha = 0.5;
            } completion:complete];
            break;
        }
        case kCGFlowCategoryModalDismiss: {
            [UIView animateWithDuration:flow.duration animations: ^{
                fromView.transform = CGAffineTransformMakeScale(0.0, 0.0);
                toView.alpha = 1.0;
            } completion:complete];
            break;
        }
        case kCGFlowCategoryPanelPresent: {
            [fromView setFrame:flow.source.startPosition];
            [flow.containerView insertSubview:toView belowSubview:fromView];
            [UIView animateWithDuration:flow.duration animations: ^{
                [toView setFrame:flow.destination.endPosition];
                [fromView setFrame:flow.source.endPosition];
            } completion:complete];
            break;
        }
        case kCGFlowCategoryPanelDismiss: {
            [toView setFrame:flow.destination.startPosition];
            [UIView animateWithDuration:flow.duration animations: ^{
                [toView setFrame:flow.destination.endPosition];
            } completion:complete];
            break;
        }
        default:
            NSLog(@"Error: Unknown Animation Type");
            break;
    }
}

+ (void)flowModalSlideUp:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.destination.size = flowObj.flowController.modalScale;
    [flowObj.destination setStartPos:CGPointMake(0, 1)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowModalSlideDown:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.destination.size = flowObj.flowController.modalScale;
    [flowObj.destination setStartPos:CGPointMake(0, -1)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowModalSlideLeft:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.destination.size = flowObj.flowController.modalScale;
    [flowObj.destination setStartPos:CGPointMake(1, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowModalSlideRight:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.destination.size = flowObj.flowController.modalScale;
    [flowObj.destination setStartPos:CGPointMake(-1, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowModalDismissCenterDisappear:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.source.size = flowObj.flowController.modalScale;
    [flowObj.destination setStartPos:CGPointMake(0, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 1)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowModalDismissDisappearAtPoint:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.source.size = flowObj.flowController.modalScale;
    [flowObj.destination setStartPos:CGPointMake(0, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 1)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
    
//    UIView *fromView = srcController.view;
//    UIView *toView = destController.view;
//    [UIView animateWithDuration:duration animations: ^{
//        [fromView setCenter:point];
//        fromView.transform = CGAffineTransformMakeScale(0.0, 0.0);
//        toView.alpha = 1.0;
//    } completion:complete];
}

+ (void)flowPanelSlideLeft:(CGFlowObject *)flowObj completion:(Completion)complete
{
    [flowObj.source.viewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [flowObj.source.viewController.view.layer setShadowOpacity:0.8];
    [flowObj.source.viewController.view.layer setShadowRadius:3.0];
    [flowObj.source.viewController.view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [flowObj.source setStartPos:CGPointMake(0, 0)];
    [flowObj.source setEndPos:CGPointMake(-0.7, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowPanelSlideRight:(CGFlowObject *)flowObj completion:(Completion)complete
{
    [flowObj.source.viewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [flowObj.source.viewController.view.layer setShadowOpacity:0.8];
    [flowObj.source.viewController.view.layer setShadowRadius:3.0];
    [flowObj.source.viewController.view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [flowObj.source setStartPos:CGPointMake(0, 0)];
    [flowObj.source setEndPos:CGPointMake(0.7, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowPanelDismissRight:(CGFlowObject *)flowObj  completion:(Completion)complete
{
    [flowObj.destination setStartPos:CGPointMake(0.7, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowPanelDismissLeft:(CGFlowObject *)flowObj completion:(Completion)complete
{
    [flowObj.destination setStartPos:CGPointMake(-0.7, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowSlideUpFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    [flowObj.source setEndPos:CGPointMake(0, -1)];
    [flowObj.destination setStartPos:CGPointMake(0, 1)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowSlideDownFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    [flowObj.source setEndPos:CGPointMake(0, 1)];
    [flowObj.destination setStartPos:CGPointMake(0, -1)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowSlideLeftFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    [flowObj.source setEndPos:CGPointMake(-1, 0)];
    [flowObj.destination setStartPos:CGPointMake(1, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowSlideRightFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    [flowObj.source setEndPos:CGPointMake(1, 0)];
    [flowObj.destination setStartPos:CGPointMake(-1, 0)];
    [flowObj.destination setEndPos:CGPointMake(0, 0)];
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowFlipUpFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.source.stageOneTransform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
    flowObj.destination.preAnimationTransform = CATransform3DMakeRotation(-1.0 * M_PI_2, 1, 0, 0);
    flowObj.destination.stageTwoTransform = CATransform3DMakeRotation(0, 1, 0, 0);
    flowObj.threeDimensionalAnimation = true;
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowFlipDownFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.source.stageOneTransform = CATransform3DMakeRotation(-1.0 * M_PI_2, 1, 0, 0);
    flowObj.destination.preAnimationTransform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
    flowObj.destination.stageTwoTransform = CATransform3DMakeRotation(0, 1, 0, 0);
    flowObj.threeDimensionalAnimation = true;
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowFlipLeftFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.source.stageOneTransform = CATransform3DMakeRotation(-1.0 * M_PI_2, 0, 1, 0);
    flowObj.destination.preAnimationTransform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    flowObj.destination.stageTwoTransform = CATransform3DMakeRotation(0, 0, 1, 0);
    flowObj.threeDimensionalAnimation = true;
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (void)flowFlipRightFromSource:(CGFlowObject *)flowObj completion:(Completion)complete
{
    flowObj.source.stageOneTransform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    flowObj.destination.preAnimationTransform = CATransform3DMakeRotation(-1.0 * M_PI_2, 0, 1, 0);
    flowObj.destination.stageTwoTransform = CATransform3DMakeRotation(0, 0, 1, 0);
    flowObj.threeDimensionalAnimation = true;
    [self genericAnimationWithFlow:flowObj andCompletion:complete];
}

+ (CGFlowAnimationType)correctForOrientation:(UIInterfaceOrientation)orientation withAnimation:(CGFlowAnimationType)animation
{
//    if (animation == kCGFlowModalPresent || animation == kCGFlowModalDismiss) {
        return animation;
//    }
    
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

+ (CGFlowAnimationCategory)animationCategoryForType:(CGFlowAnimationType)animationType
{
    if (animationType == kCGFlowAnimationSlideUp || animationType == kCGFlowAnimationSlideDown || animationType == kCGFlowAnimationSlideLeft || animationType == kCGFlowAnimationSlideRight) {
        return kCGFlowCategory2DAnimation;
    } else if (animationType == kCGFlowAnimationFlipUp || animationType == kCGFlowAnimationFlipDown || animationType == kCGFlowAnimationFlipLeft || animationType == kCGFlowAnimationFlipRight) {
        return kCGFlowCategory3DAnimation;
    } else if (animationType == kCGFlowModalPresentSlideUp || animationType == kCGFlowModalPresentSlideDown || animationType == kCGFlowModalPresentSlideLeft || animationType == kCGFlowModalPresentSlideRight) {
        return kCGFlowCategoryModalPresent;
    } else if (animationType == kCGFlowModalDismissDisappearCenter || animationType == kCGFlowModalDismissDisappearPoint) {
        return kCGFlowCategoryModalDismiss;
    } else if (animationType == kCGFlowPanelSlideRight || animationType == kCGFlowPanelSlideLeft) {
        return kCGFlowCategoryPanelPresent;
    } else if (animationType == kCGFlowPanelRightReturn || animationType == kCGFlowPanelLeftReturn) {
        return kCGFlowCategoryPanelDismiss;
    }
    return kCGFlowCategoryNone;
}

@end
