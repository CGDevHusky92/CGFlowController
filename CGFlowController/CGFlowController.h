//
//  CGFlowController.h
//
//  Created by Charles Gorectke on 1/4/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import <UIKit/UIKit.h>

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
    kCGFlowAnimationFlipLeft,
    kCGFlowAnimationFlipRight,
    kCGFlowAnimationModalPresent,
    kCGFlowAnimationModalDismiss,
    kCGFlowAnimationNone
} kCGFlowAnimationType;

typedef void(^Completion)(BOOL finished);

@protocol CGFlowInteractiveDelegate <NSObject>
-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type;
@end

@interface CGFlowController : UIViewController <UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) UIViewController<CGFlowInteractiveDelegate> *flowedController;
-(void)flowToViewController:(UIViewController *)viewController withAnimation:(kCGFlowAnimationType)animation completion:(Completion)completion;
-(void)flowInteractivelyToViewController:(UIViewController *)viewController withAnimation:(kCGFlowAnimationType)animation completion:(Completion)completion;
-(void)flowModalViewController:(UIViewController *)viewController withScale:(CGPoint)scale completion:(Completion)completion;
-(void)flowDismissModalViewControllerWithCompletion:(Completion)completion;
@end

@interface CGFlowAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) CGFlowController *flowController;
@property (weak) UIViewController *presentedController;
@property (nonatomic, assign) kCGFlowAnimationType animationType;
@property (nonatomic, assign) BOOL interactive;
@end

@interface CGFlowInteractor : UIPercentDrivenInteractiveTransition
@property (nonatomic, weak) CGFlowController *flowController;
@end

@interface CGFlowAnimations : NSObject
+(void)flowAnimation:(kCGFlowAnimationType)animationType fromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration interactively:(BOOL)interactive withScale:(CGPoint)scale completion:(Completion)complete;
@end

@interface CGFlowInteractions : NSObject

+(kCGFlowInteractionType)determineInteractorType:(UIGestureRecognizer *)gr;
+(CGFloat)percentageOfGesture:(UIGestureRecognizer *)gr withInteractor:(kCGFlowInteractionType)interactorType;

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

@end

#pragma mark - UISplitHackController to modally transition UISplitViewController

@interface UISplitHackController : UIViewController
@property (nonatomic, strong) UISplitViewController *splitController;
@end

#pragma mark - UIViewController(CGFlowController) Category

@interface UIViewController(CGFlowController) <CGFlowInteractiveDelegate>
@property (nonatomic, weak) CGFlowController *flowController;
@property (nonatomic, assign) BOOL transitioning;
@end