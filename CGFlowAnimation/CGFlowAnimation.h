//
//  CGFlowInteractions.h
//  CGFlowSlideLeftTransition
//
//  Created by Chase Gorectke on 12/24/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    kCGFlowInteractionMainEdge      = 0x00,
    kCGFlowInteractionMainPan       = 0x01,
    kCGFlowInteractionMainPress     = 0x02,
    kCGFlowInteractionMainPinch     = 0x04,
    kCGFlowInteractionMainRotate    = 0x08,
    kCGFlowInteractionMainSwipe     = 0x10,
    kCGFlowInteractionMainTap       = 0x20
} kCGFlowInteractionMainType;

typedef enum {
    kCGFlowInteractionSwipeUp,
    kCGFlowInteractionSwipeDown,
    kCGFlowInteractionSwipeLeft,
    kCGFlowInteractionSwipeRight,
    kCGFlowInteractionEdgeTop,
    kCGFlowInteractionEdgeBottom,
    kCGFlowInteractionEdgeLeft,
    kCGFlowInteractionEdgeRight,
    kCGFlowInteractionSwipeUpDouble,
    kCGFlowInteractionSwipeDownDouble,
    kCGFlowInteractionSwipeLeftDouble,
    kCGFlowInteractionSwipeRightDouble,
    kCGFlowInteractionSwipeUpTriple,
    kCGFlowInteractionSwipeDownTriple,
    kCGFlowInteractionSwipeLeftTriple,
    kCGFlowInteractionSwipeRightTriple,
    kCGFlowInteractionSingleTap,
    kCGFlowInteractionDoubleTap,
    kCGFlowInteractionTripleTap,
    kCGFlowInteractionSingleTapDouble,
    kCGFlowInteractionDoubleTapDouble,
    kCGFlowInteractionTripleTapDouble,
    kCGFlowInteractionSingleTapTriple,
    kCGFlowInteractionDoubleTapTriple,
    kCGFlowInteractionTripleTapTriple,
    kCGFlowInteractionLongPress,
    kCGFlowInteractionLongPressDouble,
    kCGFlowInteractionLongPressTriple,
    kCGFlowInteractionPinchIn,
    kCGFlowInteractionPinchOut,
    kCGFlowInteractionRotateClockwise,
    kCGFlowInteractionRotateCounterClockwise,
    kCGFlowInteractionNone
} kCGFlowInteractionType;

typedef enum kCGFlowAnimationType {
    kCGFlowAnimationSlideUp,
    kCGFlowAnimationSlideDown,
    kCGFlowAnimationSlideLeft,
    kCGFlowAnimationSlideRight,
    kCGFlowAnimationFlipUp,
    kCGFlowAnimationFlipDown,
    kCGFlowAnimationNone
} kCGFlowAnimationType;

typedef void(^completion)(void);

@class CGFlowAnimation;
@protocol CGFlowInteractiveDelegate <NSObject>
-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type;
@optional
-(void)transitionDidBeginPresentation:(CGFlowAnimation *)transition;
-(void)transitionDidCancelPresentation:(CGFlowAnimation *)transition;
-(void)transitionDidPresent:(CGFlowAnimation *)transition;
-(BOOL)transitionShouldBegin:(CGFlowAnimation *)transition;
@end

@interface CGFlowAnimation : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate>
@property (nonatomic, assign) enum kCGFlowAnimationType animationType;
@property (assign) CGFloat duration;

@property (nonatomic, weak) UIViewController<CGFlowInteractiveDelegate> *delegate;
@property (nonatomic, weak) UIViewController *presentedController;
-(void)setDelegate:(UIViewController<CGFlowInteractiveDelegate> *)delegate withOptions:(kCGFlowInteractionMainType)type;
@end

@interface CGFlowInteractions : NSObject

+(CGFloat)flowEdgeTopPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr;
+(CGFloat)flowEdgeBottomPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr;
+(CGFloat)flowEdgeLeftPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr;
+(CGFloat)flowEdgeRightPercentageFromRecognizer:(UIScreenEdgePanGestureRecognizer *)sgr;

+(CGFloat)flowPanUpPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;
+(CGFloat)flowPanDownPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;
+(CGFloat)flowPanLeftPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;
+(CGFloat)flowPanRightPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;

+(CGFloat)flowPressPercentageFromRecognizer:(UILongPressGestureRecognizer *)lgr withDuration:(CGFloat)duration;

+(CGFloat)flowPinchInPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr;
+(CGFloat)flowPinchOutPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr;

+(CGFloat)flowRotateClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr;
+(CGFloat)flowRotateCounterClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr;

+(CGFloat)flowTapPercentageFromRecognizer:(UITapGestureRecognizer *)tgr;

+(kCGFlowInteractionType)determineEdgeType:(UIScreenEdgePanGestureRecognizer *)edgeGesture;
+(kCGFlowInteractionType)determinePanType:(UIPanGestureRecognizer *)panGesture;
+(kCGFlowInteractionType)determinePressType:(UILongPressGestureRecognizer *)pressGesture;
+(kCGFlowInteractionType)determinePinchType:(UIPinchGestureRecognizer *)pinchGesture;
+(kCGFlowInteractionType)determineRotateType:(UIRotationGestureRecognizer *)rotateGesture;
+(kCGFlowInteractionType)determineTapType:(UITapGestureRecognizer *)tapGesture;

+(kCGFlowInteractionType)oppositeInteraction:(kCGFlowInteractionType)type;

@end

/* *************** Abstract CGFlowAnimationTransition Definition ************** */

@interface CGFlowAnimationTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) kCGFlowAnimationType animationType;
@property (nonatomic, assign) CGFloat duration;
@property (assign) BOOL wasCancelled;
@property (assign) UIInterfaceOrientation orientation;
@property (weak) UIViewController* presentedController;
@end

@interface CGFlowAnimations : NSObject

+(void)flowSlideUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController
             withInContainer:(UIView *)containerView initialFrame:(CGRect)initialFrame andDuration:(CGFloat)duration completion:(completion)complete;

+(void)flowSlideDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController
               withInContainer:(UIView *)containerView initialFrame:(CGRect)initialFrame andDuration:(CGFloat)duration completion:(completion)complete;

+(void)flowSlideLeftFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController
               withInContainer:(UIView *)containerView initialFrame:(CGRect)initialFrame andDuration:(CGFloat)duration completion:(completion)complete;

+(void)flowSlideRightFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController
                withInContainer:(UIView *)containerView initialFrame:(CGRect)initialFrame andDuration:(CGFloat)duration completion:(completion)complete;

+(void)flowFlipUpFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController
            withInContainer:(UIView *)containerView initialFrame:(CGRect)initialFrame andDuration:(CGFloat)duration completion:(completion)complete;

+(void)flowFlipDownFromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController
              withInContainer:(UIView *)containerView initialFrame:(CGRect)initialFrame andDuration:(CGFloat)duration completion:(completion)complete;

+(kCGFlowAnimationType)oppositeType:(kCGFlowAnimationType)type;

@end

/* ****************** Abstract CGFlowAnimation End ****************** */

#pragma mark - UIViewController(CGFlowInteractor) Category

@interface UIViewController(CGFlowInteractor) <CGFlowInteractiveDelegate>
@property (nonatomic, strong) CGFlowAnimation *loadInteractor;
@property (nonatomic, strong) CGFlowAnimation *unloadInteractor;
@end