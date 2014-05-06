//
//  CGFlowController.h
//
//  Created by Charles Gorectke on 1/4/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCGFlowModalPresent     (kCGFlowModalPresentSlideUp || kCGFlowModalPresentSlideDown || kCGFlowModalPresentSlideLeft || kCGFlowModalPresentSlideRight)
#define kCGFlowModalDismiss     (kCGFlowModalDismissDisappearCenter || kCGFlowModalDismissDisappearPoint)

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
    kCGFlowInteractionPinchIn,
    kCGFlowInteractionPinchOut,
    kCGFlowInteractionRotateClockwise,
    kCGFlowInteractionRotateCounterClockwise,
    kCGFlowInteractionNone
} CGFlowInteractionType;

typedef enum CGFlowAnimationType {
    kCGFlowAnimationSlideUp,
    kCGFlowAnimationSlideDown,
    kCGFlowAnimationSlideLeft,
    kCGFlowAnimationSlideRight,
    kCGFlowAnimationFlipUp,
    kCGFlowAnimationFlipDown,
    kCGFlowAnimationFlipLeft,
    kCGFlowAnimationFlipRight,
    kCGFlowModalPresentSlideUp,
    kCGFlowModalPresentSlideDown,
    kCGFlowModalPresentSlideLeft,
    kCGFlowModalPresentSlideRight,
    kCGFlowModalDismissDisappearCenter,
    kCGFlowModalDismissDisappearPoint,
    kCGFlowModalPanelSlideRight,
    kCGFlowModalPanelSlideLeft,
    kCGFlowModalPanelReturn,
    kCGFlowAnimationNone
} CGFlowAnimationType;

typedef void(^Completion)(BOOL finished);

@protocol CGFlowInteractiveDelegate <NSObject>

- (void)proceedToNextViewControllerWithTransition:(CGFlowInteractionType)type;

@end

@interface CGFlowController : UIViewController <UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) UIViewController<CGFlowInteractiveDelegate> *flowedController;

/* Modal Appearence calls? */
- (void)flowModalViewWillAppear:(BOOL)animated;
- (void)flowModalViewDidAppear:(BOOL)animated;
- (void)flowModalViewWillDisappear:(BOOL)animated;
- (void)flowModalViewDidDisappear:(BOOL)animated;

/* Standard Dynamic Flow Interactively or Not */
- (void)flowToViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andDuration:(CGFloat)duration completion:(Completion)completion;
- (void)flowInteractivelyToViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion;

/* Flow Modal Presentation */
- (void)flowModalViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andScale:(CGPoint)scale completion:(Completion)completion;
- (void)flowDismissModalViewControllerWithAnimation:(CGFlowAnimationType)animation andCompletion:(Completion)completion;

/* Flow Panel Presentation */
- (void)flowWithBackPanel:(UIViewController *)panelController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion;
- (void)flowDismissPanelWithCompletion:(Completion)completion;

/* Modal Tap Out Gesture Recognizer */
- (void)flowModalTapOutWithAnimation:(CGFlowAnimationType)animation withCompletion:(Completion)completion;
- (void)flowEnableModalTapOut;
- (void)flowDisableModalTapOut;

/* Keep Memory Live Protocol */
- (UIViewController *)retrieveControllerForIdentifier:(NSString *)identifier;
- (void)flowKeepControllerMemoryLiveForIdentifier:(NSString *)identifier;
- (void)flowKeepModalMemoryLiveForIdentifier:(NSString *)identifier;
- (void)flowRemoveLiveMemoryForIdentifier:(NSString *)identifier;
- (void)flowClearLiveMemoryControllers;

@end

@interface CGFlowAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) CGFlowController *flowController;
@property (weak) UIViewController *presentedController;
@property (nonatomic, assign) CGFlowAnimationType animationType;
@property (nonatomic, assign) BOOL interactive;
@property (assign) CGFloat duration;

@end

@interface CGFlowInteractor : UIPercentDrivenInteractiveTransition

@property (nonatomic, weak) CGFlowController *flowController;

@end

@interface CGFlowAnimations : NSObject

+ (void)flowAnimation:(CGFlowAnimationType)animationType fromSource:(UIViewController *)srcController toDestination:(UIViewController *)destController withContainer:(UIView *)containerView andDuration:(CGFloat)duration interactively:(BOOL)interactive withScale:(CGPoint)scale completion:(Completion)complete;

@end

@interface CGFlowInteractions : NSObject

+ (CGFlowInteractionType)determineInteractorType:(UIGestureRecognizer *)gr;
+ (CGFloat)percentageOfGesture:(UIGestureRecognizer *)gr withInteractor:(CGFlowInteractionType)interactorType;

+ (CGFloat)flowPanUpPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;
+ (CGFloat)flowPanDownPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;
+ (CGFloat)flowPanLeftPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;
+ (CGFloat)flowPanRightPercentageFromRecognizer:(UIPanGestureRecognizer *)pgr;

+ (CGFloat)flowPinchInPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr;
+ (CGFloat)flowPinchOutPercentageFromRecognizer:(UIPinchGestureRecognizer *)pgr;

+ (CGFloat)flowRotateClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr;
+ (CGFloat)flowRotateCounterClockwisePercentageFromRecognizer:(UIRotationGestureRecognizer *)rgr;

+ (CGFlowInteractionType)determinePanType:(UIPanGestureRecognizer *)panGesture;
+ (CGFlowInteractionType)determinePinchType:(UIPinchGestureRecognizer *)pinchGesture;
+ (CGFlowInteractionType)determineRotateType:(UIRotationGestureRecognizer *)rotateGesture;

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