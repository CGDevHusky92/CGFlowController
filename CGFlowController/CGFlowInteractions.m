//
//  CGFlowInteractions.m
//
//  Created by Charles Gorectke on 1/7/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import "CGFlowController.h"

#define DEFAULT_GESTURE_ENHANCER    1.2

@implementation CGFlowInteractions

+(kCGFlowInteractionType)determineInteractorType:(UIGestureRecognizer *)gr {
    if ([gr isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return [self determineEdgeType:(UIScreenEdgePanGestureRecognizer *)gr];
    } else if ([gr isKindOfClass:[UIPanGestureRecognizer class]]) {
        return [self determinePanType:(UIPanGestureRecognizer *)gr];
    } else if ([gr isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return [self determinePressType:(UILongPressGestureRecognizer *)gr];
    } else if ([gr isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return [self determinePinchType:(UIPinchGestureRecognizer *)gr];
    } else if ([gr isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return [self determineRotateType:(UIRotationGestureRecognizer *)gr];
    } else if ([gr isKindOfClass:[UITapGestureRecognizer class]]) {
        return [self determineTapType:(UITapGestureRecognizer *)gr];
    }
    return kCGFlowInteractionNone;
}

+(CGFloat)percentageOfGesture:(UIGestureRecognizer *)gr withInteractor:(kCGFlowInteractionType)interactorType {
    CGFloat percentage;
    if (interactorType == kCGFlowInteractionNone) {
        percentage = 0.0;
    } else {
        if ([gr isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            if (interactorType == kCGFlowInteractionEdgeTop) {
                percentage = [self flowEdgeTopPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionEdgeBottom) {
                percentage = [self flowEdgeBottomPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionEdgeLeft) {
                percentage = [self flowEdgeLeftPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionEdgeRight) {
                percentage = [self flowEdgeRightPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)gr];
            } else {
                percentage = 0.0;
            }
        } else if ([gr isKindOfClass:[UIPanGestureRecognizer class]]) {
            if (interactorType == kCGFlowInteractionSwipeUp) {
                percentage = [self flowPanUpPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionSwipeDown) {
                percentage = [self flowPanDownPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionSwipeLeft) {
                percentage = [self flowPanLeftPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else if (interactorType == kCGFlowInteractionSwipeRight) {
                percentage = [self flowPanRightPercentageFromRecognizer:(UIPanGestureRecognizer *)gr];
            } else {
                percentage = 0.0;
            }
        } else if ([gr isKindOfClass:[UILongPressGestureRecognizer class]]) {
            if (interactorType == kCGFlowInteractionLongPress) {
                CGFloat duration = [((UILongPressGestureRecognizer *)gr) minimumPressDuration];
                percentage = [self flowPressPercentageFromRecognizer:(UILongPressGestureRecognizer *)gr withDuration:duration];
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
        } else if ([gr isKindOfClass:[UITapGestureRecognizer class]]) {
            if (interactorType == kCGFlowInteractionSingleTap) {
                percentage = [self flowTapPercentageFromRecognizer:(UITapGestureRecognizer *)gr];
            } else {
                percentage = 0.0;
            }
        } else {
            percentage = 0.0;
        }
    }
    
    return percentage;
}

+(CGFloat)flowEdgeTopPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr {
    CGPoint translation = [sgr translationInView:sgr.view.superview];
    CGFloat percentage  = translation.y / CGRectGetHeight(sgr.view.bounds);
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowEdgeBottomPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr {
    CGPoint translation = [sgr translationInView:sgr.view.superview];
    CGFloat percentage  = -(translation.y / CGRectGetHeight(sgr.view.bounds));
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowEdgeLeftPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr {
    CGPoint translation = [sgr translationInView:sgr.view.superview];
    CGFloat percentage  = -(translation.x / CGRectGetWidth(sgr.view.bounds));
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowEdgeRightPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr {
    CGPoint translation = [sgr translationInView:sgr.view.superview];
    CGFloat percentage  = translation.x / CGRectGetWidth(sgr.view.bounds);
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowPanUpPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr {
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = -(translation.y / CGRectGetHeight(pgr.view.bounds));
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowPanDownPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr {
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = translation.y / CGRectGetHeight(pgr.view.bounds);
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowPanLeftPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr {
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = -(translation.x / CGRectGetWidth(pgr.view.bounds));
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowPanRightPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr {
    CGPoint translation = [pgr translationInView:pgr.view.superview];
    CGFloat percentage  = translation.x / CGRectGetWidth(pgr.view.bounds);
    return (percentage * DEFAULT_GESTURE_ENHANCER);
}

+(CGFloat)flowPressPercentageFromRecognizer:(UILongPressGestureRecognizer *)lgr withDuration:(CGFloat)duration {
    return 1.0;
}

+(CGFloat)flowPinchInPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr {
    return (fabs(1.0 - [pgr scale]));
}

+(CGFloat)flowPinchOutPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr {
    return (([pgr scale] / 3.5) - .3);
}

+(CGFloat)flowRotateClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr {
    return rgr.rotation;
}

+(CGFloat)flowRotateCounterClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr {
    return fabs(rgr.rotation);
}

+(CGFloat)flowTapPercentageFromRecognizer:(UITapGestureRecognizer *)tgr {
    return 1.0;
}

+(kCGFlowInteractionType)determineEdgeType:(UIScreenEdgePanGestureRecognizer *)edgeGesture {
    CGPoint velocity = [edgeGesture velocityInView:edgeGesture.view.superview];
    CGFloat xVel = velocity.x;
    CGFloat yVel = velocity.y;
    if (fabs(xVel) > fabs(yVel)) {
        if (xVel > 0) {
            NSLog(@"Edge Right");
            return kCGFlowInteractionEdgeRight;
        } else {
            NSLog(@"Edge Left");
            return kCGFlowInteractionEdgeLeft;
        }
    } else {
        if (yVel > 0) {
            NSLog(@"Edge Top");
            return kCGFlowInteractionEdgeTop;
        } else {
            NSLog(@"Edge Bottom");
            return kCGFlowInteractionEdgeBottom;
        }
    }
    return kCGFlowInteractionNone;
}

+(kCGFlowInteractionType)determinePanType:(UIPanGestureRecognizer *)panGesture {
    CGPoint velocity = [panGesture velocityInView:panGesture.view.superview];
    CGFloat xVel = velocity.x;
    CGFloat yVel = velocity.y;
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

+(kCGFlowInteractionType)determinePressType:(UILongPressGestureRecognizer *)pressGesture {
    if ([pressGesture numberOfTouches] == 1) {
        NSLog(@"single long press");
        return kCGFlowInteractionLongPress;
    } else if ([pressGesture numberOfTouches] == 2) {
        NSLog(@"double long press");
        return kCGFlowInteractionLongPressDouble;
    } else if ([pressGesture numberOfTouches] == 3) {
        NSLog(@"triple long press");
        return kCGFlowInteractionLongPressTriple;
    }
    return kCGFlowInteractionNone;
}

+(kCGFlowInteractionType)determinePinchType:(UIPinchGestureRecognizer *)pinchGesture {
    if (pinchGesture.velocity > 0) {
        return kCGFlowInteractionPinchOut;
    } else {
        return kCGFlowInteractionPinchIn;
    }
}

+(kCGFlowInteractionType)determineRotateType:(UIRotationGestureRecognizer *)rotateGesture {
    if (rotateGesture.rotation > 0) {
        return kCGFlowInteractionRotateClockwise;
    } else {
        return kCGFlowInteractionRotateCounterClockwise;
    }
}

+(kCGFlowInteractionType)determineTapType:(UITapGestureRecognizer *)tapGesture {
    if ([tapGesture numberOfTouches] == 1) {
        if ([tapGesture numberOfTapsRequired] == 1) {
            NSLog(@"single detected");
            return kCGFlowInteractionSingleTap;
        } else if ([tapGesture numberOfTapsRequired] == 2) {
            NSLog(@"double detected");
            return kCGFlowInteractionDoubleTap;
        } else if ([tapGesture numberOfTapsRequired] == 3) {
            NSLog(@"triple detected");
            return kCGFlowInteractionTripleTap;
        }
    } else if ([tapGesture numberOfTouches] == 2) {
        if ([tapGesture numberOfTapsRequired] == 1) {
            NSLog(@"single two detected");
            return kCGFlowInteractionSingleTapDouble;
        } else if ([tapGesture numberOfTapsRequired] == 2) {
            NSLog(@"double two detected");
            return kCGFlowInteractionDoubleTapDouble;
        } else if ([tapGesture numberOfTapsRequired] == 3) {
            NSLog(@"triple two detected");
            return kCGFlowInteractionTripleTapDouble;
        }
    } else if ([tapGesture numberOfTouches] == 3) {
        if ([tapGesture numberOfTapsRequired] == 1) {
            NSLog(@"single three detected");
            return kCGFlowInteractionSingleTapTriple;
        } else if ([tapGesture numberOfTapsRequired] == 2) {
            NSLog(@"double three detected");
            return kCGFlowInteractionDoubleTapTriple;
        } else if ([tapGesture numberOfTapsRequired] == 3) {
            NSLog(@"triple three detected");
            return kCGFlowInteractionTripleTapTriple;
        }
    }
    return kCGFlowInteractionNone;
}

@end
