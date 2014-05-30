/**
 *  CGFlowController.h
 *  CGFlowController
 *
 *  Created by Charles Gorectke on 11/25/13.
 *  Copyright (c) 2014 Charles Gorectke. All rights reserved.
 *
 *  The MIT License (MIT)
 *
 *  Copyright (c) 2014 Charles Gorectke
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
 *
 *  CGFlowController is designed to do <#@"description"#>
 */

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
    kCGFlowInteractionPinchIn,
    kCGFlowInteractionPinchOut,
    kCGFlowInteractionRotateClockwise,
    kCGFlowInteractionRotateCounterClockwise,
    kCGFlowInteractionNone
} CGFlowInteractionType;

typedef enum CGFlowAnimationCategory {
    kCGFlowCategory2DAnimation,
    kCGFlowCategory3DAnimation,
    kCGFlowCategoryModalPresent,
    kCGFlowCategoryModalDismiss,
    kCGFlowCategoryPanelPresent,
    kCGFlowCategoryPanelDismiss,
    kCGFlowCategoryNone
} CGFlowAnimationCategory;

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
    kCGFlowPanelSlideRight,
    kCGFlowPanelSlideLeft,
    kCGFlowPanelLeftReturn,
    kCGFlowPanelRightReturn,
    kCGFlowAnimationNone
} CGFlowAnimationType;

typedef void(^Completion)(BOOL finished);

@protocol CGFlowInteractiveDelegate <NSObject>

- (void)proceedToNextViewControllerWithTransition:(CGFlowInteractionType)type;

@end

@interface CGFlowController : UIViewController <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) UIViewController<CGFlowInteractiveDelegate> *flowedController;
@property (assign) CGPoint modalScale;

/* Standard Dynamic Flow Interactively or Not */
- (void)flowToViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andDuration:(CGFloat)duration completion:(Completion)completion;
- (void)flowInteractivelyToViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion;

/* Flow Modal Presentation */
- (void)flowModalViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andScale:(CGPoint)scale completion:(Completion)completion;
- (void)flowDismissModalViewControllerWithAnimation:(CGFlowAnimationType)animation andCompletion:(Completion)completion;

/* Flow Panel Presentation */
- (void)flowPanel:(UIViewController *)panelController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion;
- (void)flowPanelInteractively:(UIViewController *)panelController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion;
- (void)flowDismissPanelWithAnimation:(CGFlowAnimationType)animation andCompletion:(Completion)completion;
- (void)flowDismissPanelInteractivelyWithAnimation:(CGFlowAnimationType)animation andCompletion:(Completion)completion;

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

#pragma mark - CGTransitioningContext Interface

@interface CGTransitionContext : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@property (copy, nonatomic) void (^completionBlock)(BOOL didComplete);
@property (assign, nonatomic, getter=isAnimated) BOOL animated;
@property (assign, nonatomic, getter=isInteractive) BOOL interactive;

@end

#pragma mark - CGPercentDrivenInteractiveTransition Interface

@interface CGPercentDrivenInteractiveTransition : NSObject <UIViewControllerInteractiveTransitioning>

@property (weak, nonatomic) id<UIViewControllerAnimatedTransitioning> animator;

@property (readonly) CGFloat percentComplete;
@property (readonly, nonatomic) CGFloat duration;
@property (readonly, nonatomic) CGFloat completionSpeed;
@property (readonly, nonatomic) BOOL isInteracting;

@property (readonly, nonatomic) UIViewAnimationCurve animationCurve;
@property (assign, nonatomic) UIViewAnimationCurve completionCurve;

- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator;

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

@end

#pragma mark - CGFlowAnimation Interface

@interface CGFlowAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) CGFlowController *flowController;
@property (weak, nonatomic) UIViewController *presentedController;
@property (assign, nonatomic) CGFlowAnimationType animationType;
@property (assign, nonatomic) BOOL interactive;
@property (assign) CGFloat duration;

@end

#pragma mark - CGFlowAnimation Interface

@interface CGFlowInteractor : CGPercentDrivenInteractiveTransition

@property (weak, nonatomic) CGFlowController *flowController;

@end

#pragma mark - CGFlowAnimations Interface

@class CGFlowObject;

@interface CGFlowAnimations : NSObject

+ (void)flowAnimationWithObject:(CGFlowObject *)flowObj withCompletion:(void(^)(BOOL))complete;
+ (CGFlowAnimationCategory)animationCategoryForType:(CGFlowAnimationType)animationType;

@end

#pragma mark - CGFlowInteractions Interface

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

#pragma mark - CGFlowObject

@class CGFlowView;

@interface CGFlowObject : NSObject

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) CGFlowView *source;
@property (strong, nonatomic) CGFlowView *destination;
@property (weak, nonatomic) CGFlowController *flowController;

@property (assign) CGFlowAnimationType animationType;
@property (assign) CGFloat duration;

@property (assign) BOOL interactive;
@property (assign) BOOL threeDimensionalAnimation;
@property (assign) BOOL affeineTransform;

@end

#pragma mark - CGFlowView

@interface CGFlowView : NSObject

@property (weak, nonatomic) CGFlowObject *parent;
@property (strong, nonatomic) UIViewController *viewController;

@property (assign, readonly) CGRect startPosition;
@property (assign, readonly) CGRect endPosition;

@property (assign) CGFloat alpha;
@property (assign) BOOL eliminate;
@property (assign) CGPoint size;

@property (assign) CATransform3D preAnimationTransform;
@property (assign) CATransform3D stageOneTransform;
@property (assign) CATransform3D stageTwoTransform;

- (instancetype)initWithParent:(CGFlowObject *)parent;

- (void)setStartPos:(CGPoint)startPos;
- (void)setEndPos:(CGPoint)endPos;

@end

#pragma mark - UISplitHackController to modally transition UISplitViewController

@interface UISplitHackController : UIViewController

@property (strong, nonatomic) UISplitViewController *splitController;

@end

#pragma mark - UIViewController(CGFlowController) Category

@interface UIViewController(CGFlowController) <CGFlowInteractiveDelegate>

@property (weak, nonatomic) CGFlowController *flowController;

@end
