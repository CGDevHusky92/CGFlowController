//
//  CGFlowInteractions.m
//
//  Created by Charles Gorectke on 1/7/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import "CGFlowController.h"

#define DEFAULT_GESTURE_ENHANCER    1.2

@implementation CGFlowInteractions

+ (CGFlowInteractionType)determineInteractorType:(UIGestureRecognizer *)gr
{
    if ([gr isKindOfClass:[UIPanGestureRecognizer class]]) {
        return [self determinePanType:(UIPanGestureRecognizer *)gr];
    } else if ([gr isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return [self determinePinchType:(UIPinchGestureRecognizer *)gr];
    } else if ([gr isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return [self determineRotateType:(UIRotationGestureRecognizer *)gr];
    }
    return kCGFlowInteractionNone;
}

+ (CGFloat)percentageOfGesture:(UIGestureRecognizer *)gr withInteractor:(CGFlowInteractionType)interactorType
{
    CGFloat percentage;
    if (interactorType == kCGFlowInteractionNone) {
        percentage = 0.0;
    } else {
        if ([gr isKindOfClass:[UIPanGestureRecognizer class]]) {
            if (interactorType == kCGFlowInteractionSwipeUp || interactorType == kCGFlowInteractionEdgeBottom) {
                percentage = [self flowPanUpPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionSwipeDown || interactorType == kCGFlowInteractionEdgeTop) {
                percentage = [self flowPanDownPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionSwipeLeft || interactorType == kCGFlowInteractionEdgeRight) {
                percentage = [self flowPanLeftPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionSwipeRight || interactorType == kCGFlowInteractionEdgeLeft) {
                percentage = [self flowPanRightPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else {
                percentage = 0.0;
            }
        } else if ([gr isKindOfClass:[UIPinchGestureRecognizer class]]) {
            if (interactorType == kCGFlowInteractionPinchIn) {
                percentage = [self flowPinchInPercentageFromRecognizer:(UIPinchGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionPinchOut) {
                percentage = [self flowPinchOutPercentageFromRecognizer:(UIPinchGestureRecognizer *)gr];
            } else {
                percentage = 0.0;
            }
        } else if ([gr isKindOfClass:[UIRotationGestureRecognizer class]]) {
            if (interactorType == kCGFlowInteractionRotateClockwise) {
                percentage = [self flowRotateClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionRotateCounterClockwise) {
                percentage = [self flowRotateCounterClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)gr];
            } else {
                percentage = 0.0;
            }
        } else {
            percentage = 0.0;
        }
    }
    
    return percentage;
}

+ (CGFloat)flowPanUpPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr
{
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = -(translation.y / CGRectGetHeight(pgr.view.bounds));
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+ (CGFloat)flowPanDownPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr
{
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = translation.y / CGRectGetHeight(pgr.view.bounds);
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+ (CGFloat)flowPanLeftPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr
{
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = -(translation.x / CGRectGetWidth(pgr.view.bounds));
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+ (CGFloat)flowPanRightPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr
{
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = translation.x / CGRectGetWidth(pgr.view.bounds);
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+ (CGFloat)flowPinchInPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr
{
    return (fabs(1.0 - [pgr scale]));
}

+ (CGFloat)flowPinchOutPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr
{
    return (([pgr scale] / 3.5) - .3);
}

+ (CGFloat)flowRotateClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr
{
    return rgr.rotation;
}

+ (CGFloat)flowRotateCounterClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr
{
    return fabs(rgr.rotation);
}

+ (CGFlowInteractionType)determinePanType:(UIPanGestureRecognizer *)panGesture
{
    CGPoint location = [panGesture locationInView:panGesture.view.superview];
    CGPoint velocity = [panGesture velocityInView:panGesture.view.superview];
    CGFloat xVel = velocity.x;
    CGFloat yVel = velocity.y;
    
    if ((location.y < (panGesture.view.superview.frame.size.height * 0.1)) && (fabs(xVel) < fabs(yVel)) && (yVel > 0)) {
        return kCGFlowInteractionEdgeTop;
    } else if ((location.y > (panGesture.view.superview.frame.size.height * 0.9)) && (fabs(xVel) < fabs(yVel)) && (yVel < 0)) {
        return kCGFlowInteractionEdgeBottom;
    } else if ((location.x < (panGesture.view.superview.frame.size.width * 0.1)) && (fabs(xVel) > fabs(yVel)) && (xVel > 0)) {
        return  kCGFlowInteractionEdgeLeft;
    } else if ((location.x > (panGesture.view.superview.frame.size.width * 0.9)) && (fabs(xVel) > fabs(yVel)) && (xVel < 0)) {
        return kCGFlowInteractionEdgeRight;
    }
    
    if ([panGesture numberOfTouches] == 1) {
        if (fabs(xVel) > fabs(yVel)) {
            if (xVel > 0) {
                return kCGFlowInteractionSwipeRight;
            } else {
                return kCGFlowInteractionSwipeLeft;
            }
        } else {
            if (yVel > 0) {
                return kCGFlowInteractionSwipeDown;
            } else {
                return kCGFlowInteractionSwipeUp;
            }
        }
    } else if ([panGesture numberOfTouches] == 2) {
        if (fabs(xVel) > fabs(yVel)) {
            if (xVel > 0) {
                return kCGFlowInteractionSwipeRightDouble;
            } else {
                return kCGFlowInteractionSwipeLeftDouble;
            }
        } else {
            if (yVel > 0) {
                return kCGFlowInteractionSwipeDownDouble;
            } else {
                return kCGFlowInteractionSwipeUpDouble;
            }
        }
    } else if ([panGesture numberOfTouches] == 3) {
        if (fabs(xVel) > fabs(yVel)) {
            if (xVel > 0) {
                return kCGFlowInteractionSwipeRightTriple;
            } else {
                return kCGFlowInteractionSwipeLeftTriple;
            }
        } else {
            if (yVel > 0) {
                return kCGFlowInteractionSwipeDownTriple;
            } else {
                return kCGFlowInteractionSwipeUpTriple;
            }
        }
    }
    return kCGFlowInteractionNone;
}

+ (CGFlowInteractionType)determinePinchType:(UIPinchGestureRecognizer *)pinchGesture
{
    if (pinchGesture.velocity > 0) {
        return kCGFlowInteractionPinchOut;
    } else {
        return kCGFlowInteractionPinchIn;
    }
}

+ (CGFlowInteractionType)determineRotateType:(UIRotationGestureRecognizer *)rotateGesture
{
    if (rotateGesture.rotation > 0) {
        return kCGFlowInteractionRotateClockwise;
    } else {
        return kCGFlowInteractionRotateCounterClockwise;
    }
}

@end
