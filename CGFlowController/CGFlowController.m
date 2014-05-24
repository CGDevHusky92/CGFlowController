//
//  CGFlowController.m
//
//  Created by Charles Gorectke on 1/4/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CGFlowController.h"
#import "objc/runtime.h"

#define willDidMove
#define appearanceTransition

@interface CGFlowController ()

@property (nonatomic, weak) UIViewController *statusController;
@property (nonatomic, weak) UIViewController *modalController;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSMutableDictionary *liveControllerDic;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) CGFlowInteractor *interactor;
@property (nonatomic, assign) CGFlowAnimationType animationType;
@property (nonatomic, assign) CGFlowAnimationType modalTapDismissAnimation;
@property (nonatomic, strong) Completion modalTapCompletion;
@property (nonatomic, strong) Completion currentCompletion;

//@property (assign) CGPoint modalScale;
@property (assign) CGFloat duration;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL started;

@end

@implementation CGFlowController

- (void)loadView
{
    UIView *rootView = [[UIView alloc] init];
	rootView.backgroundColor = [UIColor blackColor];
	rootView.opaque = YES;
	
	self.containerView = [[UIView alloc] init];
	self.containerView.backgroundColor = [UIColor blackColor];
	self.containerView.opaque = YES;
	
	[self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[rootView addSubview:self.containerView];
	
	// Container view fills out entire root view.
	[rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	[rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	[rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	self.view = rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _duration = 0.4;
    _started = false;
    _modalScale = CGPointZero;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.definesPresentationContext = YES;
    self.providesPresentationContextTransitionStyle = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.interactor = [CGFlowInteractor new];
    [self.interactor setFlowController:self];
    
    UIViewController *initController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        initController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"CGFlowInitialScene"];
    } else {
        initController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"CGFlowInitialScene"];
    }
    
    if (initController) {
        [self addChildViewController:initController];
        initController.view.frame = self.view.bounds;
        [self.view addSubview:initController.view];
        [initController didMoveToParentViewController:self];
        initController.flowController = self;
        _statusController = initController;
        _flowedController = initController;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - View Appearence Calls

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_started) {
        self.flowedController.transitioning = YES;
        [self.flowedController beginAppearanceTransition:YES animated:NO];
        self.flowedController.transitioning = NO;
    }
    if (_modalController) {
        self.modalController.transitioning = YES;
        [self.modalController beginAppearanceTransition:YES animated:YES];
        self.modalController.transitioning = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_started) {
        _started = true;
        self.flowedController.transitioning = YES;
        [self.flowedController endAppearanceTransition];
        self.flowedController.transitioning = NO;
    }
    if (_modalController) {
        self.modalController.transitioning = YES;
        [self.modalController endAppearanceTransition];
        self.modalController.transitioning = NO;
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_modalController) {
        self.modalController.transitioning = YES;
        [self.modalController beginAppearanceTransition:NO animated:YES];
        self.modalController.transitioning = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (_modalController) {
        self.modalController.transitioning = YES;
        [self.modalController endAppearanceTransition];
        self.modalController.transitioning = NO;
    }
    [super viewDidDisappear:animated];
}

- (void)flowToViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andDuration:(CGFloat)duration completion:(Completion)completion
{
    [self flowViewController:viewController withAnimation:animation andDuration:duration interactively:NO completion:completion];
}

- (void)flowInteractivelyToViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion
{
    [self flowViewController:viewController withAnimation:animation andDuration:0.0 interactively:YES completion:completion];
}

- (void)flowViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andDuration:(CGFloat)duration interactively:(BOOL)interactive completion:(Completion)completion
{
    if (animation < kCGFlowAnimationSlideUp || animation >= kCGFlowAnimationNone) return;
    
    _statusController = viewController;
    UIViewController *tempController = viewController;
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitHackController *splitController = [[UISplitHackController alloc] init];
        [splitController setSplitController:(UISplitViewController *)viewController];
        tempController = (UIViewController *)splitController;
    }
    
    if (interactive) {
        self.interactive = YES;
    } else {
        _duration = duration;
        self.interactive = NO;
    }
    
    tempController.transitioningDelegate = self;
    tempController.modalPresentationStyle = UIModalPresentationCustom;
    _animationType = animation;
    _currentCompletion = completion;
    
    [self startTransition:tempController];
    
}

- (void)startTransition:(UIViewController *)toViewController
{
	if (toViewController == _flowedController || ![self isViewLoaded]) return;
	
	UIView *toView = toViewController.view;
	[toView setTranslatesAutoresizingMaskIntoConstraints:YES];
	toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	toView.frame = self.containerView.bounds;
	
	[_flowedController willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];
    
    CGTransitionContext *context = [[CGTransitionContext alloc] initWithFromViewController:_flowedController toViewController:toViewController];
    CGFlowAnimation *animator = [CGFlowAnimation new];
    animator.animationType = _animationType;
    animator.interactive = _interactive;
    [animator setFlowController:self];
    animator.duration = _duration;
    
    if (self.interactive) {
        self.interactor.animator = animator;
        [self.interactor startInteractiveTransition:context];
    } else {
        animator.duration = _duration;
        if (_duration != 0.4) {
            _duration = 0.4;
        }
        [animator animateTransition:context];
    }
}

- (void)cancelTransition:(UIViewController *)toViewController
{
    self.interactive = NO;
    _statusController = _flowedController;
    [toViewController.view removeFromSuperview];
    [toViewController setTransitioningDelegate:nil];
    [toViewController removeFromParentViewController];
    
    [self.flowedController setNeedsStatusBarAppearanceUpdate];
    [self.flowedController.view setBounds:self.view.bounds];
    [self.flowedController.view setFrame:self.view.bounds];
}

- (void)finishTransition:(UIViewController *)toViewController
{
    self.interactive = NO;
    UIViewController *tempVc;
    if ([toViewController isKindOfClass:[UISplitHackController class]]) {
        tempVc = ((UISplitHackController *)toViewController).splitController;
    } else {
        tempVc = toViewController;
    }
    
    [_flowedController setTransitioningDelegate:nil];
    [_flowedController.view removeFromSuperview];
    [_flowedController removeFromParentViewController];
    [tempVc didMoveToParentViewController:self];
    
    _flowedController = tempVc;
    _flowedController.flowController = self;
    [self.flowedController setNeedsStatusBarAppearanceUpdate];
    [self.flowedController.view setBounds:self.view.bounds];
    [self.flowedController.view setFrame:self.view.bounds];
}

#pragma mark - Flow To Panel and Modal Transitions

- (void)flowModalViewController:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andScale:(CGPoint)scale completion:(Completion)completion
{
    self.flowedController.view.userInteractionEnabled = NO;
    [self flowGenericModel:viewController withAnimation:animation andScale:scale interactively:NO completion:completion];
}

- (void)flowPanel:(UIViewController *)panelController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion
{
    [self flowGenericModel:panelController withAnimation:animation andScale:CGPointMake(1.0, 1.0) interactively:NO completion:completion];
}

- (void)flowPanelInteractively:(UIViewController *)panelController withAnimation:(CGFlowAnimationType)animation completion:(Completion)completion
{
    [self flowGenericModel:panelController withAnimation:animation andScale:CGPointMake(1.0, 1.0) interactively:YES completion:completion];
}

- (void)flowGenericModel:(UIViewController *)viewController withAnimation:(CGFlowAnimationType)animation andScale:(CGPoint)scale interactively:(BOOL)interactive completion:(Completion)completion
{
    if (animation < kCGFlowAnimationSlideUp || animation >= kCGFlowAnimationNone) return;
    
    viewController.transitioningDelegate = self;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    _animationType = animation;
    self.interactive = interactive;
    
    _modalScale = scale;
    _currentCompletion = completion;
    [self presentViewController:viewController animated:YES completion:^{}];
}

- (void)flowDismissModalViewControllerWithAnimation:(CGFlowAnimationType)animation andCompletion:(Completion)completion
{
    [self flowGenericModelDismiss:animation interactively:NO andCompletion:completion];
}

- (void)flowDismissPanelWithAnimation:(CGFlowAnimationType)animation andCompletion:(Completion)completion
{
    [self flowGenericModelDismiss:animation interactively:NO andCompletion:completion];
}

- (void)flowDismissPanelInteractivelyWithAnimation:(CGFlowAnimationType)animation andCompletion:(Completion)completion
{
    [self flowGenericModelDismiss:animation interactively:YES andCompletion:completion];
}

- (void)flowGenericModelDismiss:(CGFlowAnimationType)animation interactively:(BOOL)interactive andCompletion:(Completion)completion
{
    if (animation < kCGFlowAnimationSlideUp || animation >= kCGFlowAnimationNone) return;
    if (self.modalController) {
        _modalController.transitioningDelegate = self;
        _modalController.modalPresentationStyle = UIModalPresentationCustom;
        _animationType = animation;
        _interactive = interactive;
        
        _currentCompletion = completion;
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)cancelPanelTransition:(UIViewController *)vc
{
    self.interactive = NO;
    __weak __block UIViewController *tempVc;
    if ([vc isKindOfClass:[UISplitHackController class]]) {
        tempVc = ((UISplitHackController *)vc).splitController;
    } else {
        tempVc = vc;
    }
    
    __weak __block CGFlowController *safeSelf = self;
    [self.modalController dismissViewControllerAnimated:NO completion:^{
        [safeSelf addChildViewController:tempVc];
        [safeSelf.view addSubview:tempVc.view];
        
        [safeSelf.modalController setTransitioningDelegate:nil];
        [safeSelf.modalController.view removeFromSuperview];
        
        [safeSelf.modalController removeFromParentViewController];
        safeSelf.modalController = tempVc;
        safeSelf.modalController.flowController = safeSelf;
        [safeSelf.modalController didMoveToParentViewController:safeSelf];
        
        // Important to reset all the bounds and frame after completion
        [UIView animateWithDuration:0.0 animations:^{
            [safeSelf.view setBounds:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
            [safeSelf.modalController.view setBounds:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
            [safeSelf.view setFrame:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
            [safeSelf.modalController.view setFrame:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
        } completion:_currentCompletion];
    }];
}

- (void)finishTransitionModal:(UIViewController *)vc appearing:(BOOL)appearing
{
    if (appearing) {
        self.interactive = NO;
        self.modalController = vc;
        self.modalController.flowController = self;
        [self.modalController didMoveToParentViewController:self];
        _currentCompletion(YES);
    } else {
        self.interactive = NO;
        [self.flowedController.view setUserInteractionEnabled:YES];
        [self.modalController.view removeFromSuperview];
        [self.modalController removeFromParentViewController];
        self.modalController = nil;
        _modalScale = CGPointZero;
        _currentCompletion(YES);
    }
}

#pragma mark - Modal Tap Out Recognizers

- (void)flowModalTapOutWithAnimation:(CGFlowAnimationType)animation withCompletion:(Completion)completion
{
    if (animation < kCGFlowAnimationSlideUp || animation >= kCGFlowAnimationNone) return;
    if (_modalController) {
        _modalTapDismissAnimation = animation;
        _modalTapCompletion = completion;
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [_tapGesture setNumberOfTapsRequired:1];
        [_tapGesture setCancelsTouchesInView:NO];
        [_modalController.presentingViewController.view addGestureRecognizer:_tapGesture];
    }
}

- (void)flowEnableModalTapOut
{
    if (_modalController && _tapGesture) {
        if (![_modalController.presentingViewController.view.gestureRecognizers containsObject:_tapGesture]) {
            [_modalController.presentingViewController.view addGestureRecognizer:_tapGesture];
        }
    }
}

- (void)flowDisableModalTapOut
{
    if (_modalController && _tapGesture) {
        if ([_modalController.presentingViewController.view.gestureRecognizers containsObject:_tapGesture]) {
            [_modalController.presentingViewController.view removeGestureRecognizer:_tapGesture];
        }
    }
}

- (void)tapView:(id)sender
{
    [self.presentingViewController.view removeGestureRecognizer:_tapGesture];
    _tapGesture = nil;
    [self flowDismissModalViewControllerWithAnimation:_modalTapDismissAnimation andCompletion:_modalTapCompletion];
}

#pragma mark - Live Memory Protocol

- (UIViewController *)retrieveControllerForIdentifier:(NSString *)identifier
{
    if (_liveControllerDic) {
        BOOL exists = NO;
        for (NSString *key in [_liveControllerDic allKeys]) {
            if ([key isEqualToString:identifier]) {
                exists = YES;
                break;
            }
        }
        if (exists) return [_liveControllerDic objectForKey:identifier];
    }
    return [self.storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (void)flowKeepControllerMemoryLiveForIdentifier:(NSString *)identifier
{
    if (!_liveControllerDic) _liveControllerDic = [[NSMutableDictionary alloc] init];
    
    BOOL exists = NO;
    for (NSString *key in [_liveControllerDic allKeys]) {
        if ([key isEqualToString:identifier]) {
            exists = YES;
            break;
        }
    }
    
    if (!exists) [_liveControllerDic setObject:self.flowedController forKey:identifier];
}

- (void)flowKeepModalMemoryLiveForIdentifier:(NSString *)identifier
{
    if (!_liveControllerDic) _liveControllerDic = [[NSMutableDictionary alloc] init];
    
    BOOL exists = NO;
    for (NSString *key in [_liveControllerDic allKeys]) {
        if ([key isEqualToString:identifier]) {
            exists = YES;
            break;
        }
    }
    
    if (!exists) [_liveControllerDic setObject:self.modalController forKey:identifier];
}

- (void)flowRemoveLiveMemoryForIdentifier:(NSString *)identifier
{
    if (_liveControllerDic)
        for (NSString *key in [_liveControllerDic allKeys])
            if ([key isEqualToString:identifier])
                [_liveControllerDic removeObjectForKey:identifier];
}

- (void)flowClearLiveMemoryControllers
{
    [_liveControllerDic removeAllObjects];
    _liveControllerDic = nil;
}

#pragma mark - Flowed Controller Delegate Method

- (void)proceedToNextViewControllerWithTransition:(CGFlowInteractionType)type
{
    [self.flowedController proceedToNextViewControllerWithTransition:type];
}

#pragma mark - Flow Controller Getters and Setters

- (void)setFlowedController:(UIViewController<CGFlowInteractiveDelegate> *)flowedController
{
    _flowedController = flowedController;
    [_flowedController setFlowController:self];
    _flowedController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

#pragma mark - UIStatusBar

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return _statusController;
}

#pragma mark - UIViewControllerTransitioningDelegate

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    CGFlowAnimation *animator = [CGFlowAnimation new];
//    animator.animationType = _animationType;
//    animator.duration = _duration;
//    if (_duration != 0.4) {
//        _duration = 0.4;
//    }
//    animator.interactive = _interactive;
//    [animator setFlowController:self];
//    return animator;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    CGFlowAnimation *animator = [CGFlowAnimation new];
//    animator.animationType = _animationType;
//    animator.interactive = _interactive;
//    animator.duration = _duration;
//    if (_duration != 0.4) {
//        _duration = 0.4;
//    }
//    [animator setFlowController:self];
//    return animator;
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    if (_interactive) {
//        self.interactor.animator = animator;
//        return self.interactor;
//    }
//    return nil;
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    if (_interactive) {
//        self.interactor.animator = animator;
//        return self.interactor;
//    }
//    return nil;
//}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

#pragma mark - CGTransitionContext Implementation

@interface CGTransitionContext ()

@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, assign) BOOL transitionWasCancelled;

@end

@implementation CGTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
	NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    self = [super init];
	if (self) {
		self.presentationStyle = UIModalPresentationCustom;
		self.containerView = fromViewController.view.superview;
        _transitionWasCancelled = NO;
		self.privateViewControllers = @{ UITransitionContextFromViewControllerKey : fromViewController, UITransitionContextToViewControllerKey : toViewController };
	}
	return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController
{
	return CGRectZero;
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
	return CGRectZero;
}

- (UIViewController *)viewControllerForKey:(NSString *)key
{
	return self.privateViewControllers[key];
}

- (void)completeTransition:(BOOL)didComplete
{
	if (self.completionBlock) {
		self.completionBlock (didComplete);
	}
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition { self.transitionWasCancelled = NO; }
- (void)cancelInteractiveTransition { self.transitionWasCancelled = YES; }

@end

#pragma mark - CGFlowAnimation Implementation

@interface CGFlowAnimation ()

@end

@implementation CGFlowAnimation
@synthesize animationType=_animationType;
@synthesize interactive=_interactive;
@synthesize duration=_duration;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGFlowObject *animation = [[CGFlowObject alloc] init];
    animation.flowController = self.flowController;
    animation.containerView = [transitionContext containerView];
    
    animation.animationType = self.animationType;
    animation.duration = [self transitionDuration:transitionContext];
    animation.interactive = _interactive;
    
    CGFlowView *source = [[CGFlowView alloc] initWithParent:animation];
    CGFlowView *destination = [[CGFlowView alloc] initWithParent:animation];
    
    source.viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    destination.viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    animation.source = source;
    animation.destination = destination;
    
    CGFlowAnimationCategory cat = [CGFlowAnimations animationCategoryForType:self.animationType];
    [CGFlowAnimations flowAnimationWithObject:animation withCompletion:^(BOOL finished) {
        if (finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if (cat == kCGFlowCategory2DAnimation || cat == kCGFlowCategory3DAnimation) {
                if ([transitionContext transitionWasCancelled]) {
                    [self.flowController cancelTransition:destination.viewController];
                } else {
                    [self.flowController finishTransition:destination.viewController];
                }
            }
//            [transitionContext completeTransition:YES];
//            if ([transitionContext transitionWasCancelled]) {
//
////                NSLog(@"Cancelled");
//                if (cat == kCGFlowCategory2DAnimation || cat == kCGFlowCategory3DAnimation) {
//
////                    [transitionContext completeTransition:YES];
//                    [self.flowController cancelTransition:destination.viewController];
//                    
//                } else {
//
////                    [transitionContext completeTransition:NO];
////                    [self.flowController cancelTransition:destination.viewController];
//                    [self.flowController cancelPanelTransition:source.viewController];
//
//                }
//
//            } else {
//
////                [transitionContext completeTransition:YES];
//                if (cat == kCGFlowCategoryModalPresent || cat == kCGFlowCategoryPanelPresent) {
//                    [self.flowController finishTransitionModal:destination.viewController appearing:YES];
//                } else if (cat == kCGFlowCategoryModalDismiss || cat == kCGFlowCategoryPanelDismiss) {
//                    [self.flowController finishTransitionModal:destination.viewController appearing:NO];
//                } else {
//                    [self.flowController finishTransition:destination.viewController];
//                }
//                
//            }
        }
    }];
}

@end

#pragma mark - CGPercentDrivenInteractiveTransition Implementation

@interface CGPercentDrivenInteractiveTransition ()

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (weak, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@property (readwrite, nonatomic) BOOL isInteracting;

@end

@implementation CGPercentDrivenInteractiveTransition

- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
{
    self = [super init];
    if (self) {
        [self genericInit];
        _animator = animator;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self genericInit];
    }
    return self;
}

- (void)genericInit
{
    _completionSpeed = 1.0;
}

#pragma mark - Class and Getter Protocol

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    self.percentComplete = fmaxf(fminf(percentComplete, 1), 0);
}

- (void)cancelInteractiveTransition
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(cancelAnimation)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_transitionContext cancelInteractiveTransition];
}

- (void)finishInteractiveTransition
{
    CALayer *layer = [_transitionContext containerView].layer;
    layer.speed = [self completionSpeed];
    
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
    [_transitionContext finishInteractiveTransition];
}

- (CGFloat)duration
{
    return [_animator transitionDuration:_transitionContext];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSAssert(_animator, @"No animator set for percent driven protocol.");
    _transitionContext = transitionContext;
    [_transitionContext containerView].layer.speed = 0;
    [_animator animateTransition:_transitionContext];
}

- (UIViewAnimationCurve)completionCurve
{
    return UIViewAnimationCurveLinear;
}

- (BOOL)isInteracting
{
    return _isInteracting;
}

#pragma mark - Internal

- (void)setPercentComplete:(CGFloat)percentComplete
{
    _percentComplete = percentComplete;
    [self setTimeOffset:percentComplete * [self duration]];
    [_transitionContext updateInteractiveTransition:percentComplete];
}

- (void)setTimeOffset:(NSTimeInterval)timeOffset
{
    [_transitionContext containerView].layer.timeOffset = timeOffset;
}

- (void)cancelAnimation
{
    NSTimeInterval timeOffset = [self timeOffset] - [_displayLink duration];
    if (timeOffset < 0)
        [self finalizeCanceling];
    else
        [self setTimeOffset:timeOffset];
}

- (CFTimeInterval)timeOffset
{
    return [_transitionContext containerView].layer.timeOffset;
}

- (void)finalizeCanceling
{
    [_displayLink invalidate];
    [_transitionContext containerView].layer.speed = 1;
}

@end

#pragma mark - CGFlowInteractor Implementation

@interface CGFlowInteractor() <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFlowInteractionType interactorType;

@end

@implementation CGFlowInteractor

- (void)setFlowController:(CGFlowController *)flowController
{
    _flowController = flowController;
    _interactorType = kCGFlowInteractionNone;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [panGesture setCancelsTouchesInView:NO];
    [pinchGesture setCancelsTouchesInView:NO];
//    [rotationGesture setCancelsTouchesInView:NO];
    
    [panGesture setDelegate:self];
    [pinchGesture setDelegate:self];
//    [rotationGesture setDelegate:self];
    
//    [_pinchGesture requireGestureRecognizerToFail:rotationGesture];
    
    [_flowController.view addGestureRecognizer:panGesture];
    [_flowController.view addGestureRecognizer:pinchGesture];
//    [_flowController.view addGestureRecognizer:rotationGesture];
}

#pragma mark - Gesture Handler

- (void)handlePan:(UIGestureRecognizer *)gr
{
    if (_interactorType == kCGFlowInteractionNone || _interactorType == kCGFlowInteractionSwipeUp || _interactorType == kCGFlowInteractionSwipeUpDouble || _interactorType == kCGFlowInteractionSwipeUpTriple || _interactorType == kCGFlowInteractionSwipeDown || _interactorType == kCGFlowInteractionSwipeDownDouble || _interactorType == kCGFlowInteractionSwipeDownTriple || _interactorType == kCGFlowInteractionSwipeLeft || _interactorType == kCGFlowInteractionSwipeLeftDouble || _interactorType == kCGFlowInteractionSwipeLeftTriple || _interactorType == kCGFlowInteractionSwipeRight || _interactorType == kCGFlowInteractionSwipeRightDouble || _interactorType == kCGFlowInteractionSwipeRightTriple || _interactorType == kCGFlowInteractionEdgeTop || _interactorType == kCGFlowInteractionEdgeBottom || _interactorType == kCGFlowInteractionEdgeLeft || _interactorType == kCGFlowInteractionEdgeRight) {
        CGFloat percentage = [CGFlowInteractions percentageOfGesture:gr withInteractor:_interactorType];
        switch (gr.state) {
            case UIGestureRecognizerStateBegan:
                _interactorType = [CGFlowInteractions determineInteractorType:gr];
                [self.flowController proceedToNextViewControllerWithTransition:_interactorType];
                break;
            case UIGestureRecognizerStateChanged: {
                if (percentage >= 1.0)
                    percentage = 0.99;
                [self updateInteractiveTransition:percentage];
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
                _interactorType = kCGFlowInteractionNone;
                if (percentage < 0.5) {
#warning test completion speed
//                    self.completionSpeed = 0.5f;
                    [self cancelInteractiveTransition];
                } else {
//                    self.completionSpeed = 1.0f;
                    [self finishInteractiveTransition];
                }
            default:
                break;
        }
    }
}

- (void)handlePinch:(UIGestureRecognizer *)gr
{
    if (_interactorType == kCGFlowInteractionNone || _interactorType == kCGFlowInteractionPinchIn || _interactorType == kCGFlowInteractionPinchOut || _interactorType == kCGFlowInteractionRotateClockwise || _interactorType == kCGFlowInteractionRotateCounterClockwise) {
        CGFloat percentage = [CGFlowInteractions percentageOfGesture:gr withInteractor:_interactorType];
        switch (gr.state) {
            case UIGestureRecognizerStateBegan:
                _interactorType = [CGFlowInteractions determineInteractorType:gr];
                [self.flowController proceedToNextViewControllerWithTransition:_interactorType];
                break;
            case UIGestureRecognizerStateChanged: {
                if (percentage >= 1.0)
                    percentage = 0.99;
                [self updateInteractiveTransition:percentage];
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
                _interactorType = kCGFlowInteractionNone;
                if (percentage < 0.5) {
#warning test completion speed
//                    self.completionSpeed = 0.5f;
                    [self cancelInteractiveTransition];
                } else {
//                    self.completionSpeed = 1.0f;
                    [self finishInteractiveTransition];
                }
            default:
                break;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

#pragma mark - CGFlowObject Implementation

@implementation CGFlowObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.4;
        _interactive = false;
        _threeDimensionalAnimation = false;
        _affeineTransform = false;
        
        _source = [[CGFlowView alloc] initWithParent:self];
        _destination = [[CGFlowView alloc] initWithParent:self];
    }
    return self;
}

@end

#pragma mark - CGFlowView Implementation

@interface CGFlowView ()

@property (assign, readwrite) CGRect startPosition;
@property (assign, readwrite) CGRect endPosition;

- (CGRect)calculateRecFromPoint:(CGPoint)position;

@end

@implementation CGFlowView

- (instancetype)initWithParent:(CGFlowObject *)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
        _size = CGPointMake(1, 1);
        _eliminate = false;
        _alpha = 1.0;
        [self setStartPos:CGPointMake(0, 0)];
        [self setEndPos:CGPointMake(0, 0)];
    }
    return self;
}

- (void)setStartPos:(CGPoint)startPos
{
    _startPosition = [self calculateRecFromPoint:startPos];
}

- (void)setEndPos:(CGPoint)endPos
{
    _endPosition = [self calculateRecFromPoint:endPos];
}

- (CGRect)calculateRecFromPoint:(CGPoint)position
{
    CGRect bounds = self.parent.containerView.bounds;
    CGFloat width = (self.size.x * bounds.size.width);
    CGFloat height = (self.size.y * bounds.size.height);
    CGFloat x = ((bounds.size.width - width) / 2) + ((position.x) * bounds.size.width);
    CGFloat y = ((bounds.size.height - height) / 2) + ((position.y) * bounds.size.height);
    CGRect frame = CGRectMake(x, y, width, height);
    return frame;
}

@end

#pragma mark - UISplitHackController

@implementation UISplitHackController
@synthesize splitController=_splitController;

- (void)setSplitController:(UISplitViewController *)splitController
{
    _splitController = splitController;
    [self.view addSubview:_splitController.view];
}

@end

#pragma mark - UIViewController(CGFlowAnimation) Category

static char flowKey;
static char transitioningKey;
static char lowestLevelKey;

@interface UIViewController() {
    CGFlowController *flowController;
    BOOL transitioning;
    BOOL lowestLevel;
}

@property (nonatomic, weak) CGFlowController *flowController;

@property (nonatomic, assign) BOOL transitioning;
@property (nonatomic, assign) BOOL lowestLevel;

@end

@implementation UIViewController (CGFlowInteractor)

- (void)proceedToNextViewControllerWithTransition:(CGFlowInteractionType)type
{
    UIViewController *tempController = self;
    if (!([tempController isKindOfClass:[UINavigationController class]] || [tempController isKindOfClass:[UITabBarController class]] || [tempController isKindOfClass:[UISplitViewController class]] || [tempController isKindOfClass:[UISplitHackController class]])) {
        // Returns if the method isn't overridden by the bottom controller
        if (self.lowestLevel) {
            self.lowestLevel = false;
            return;
        }
        self.lowestLevel = true;
    } else {
        self.lowestLevel = false;
    }
    
    while ([tempController isKindOfClass:[UINavigationController class]] || [tempController isKindOfClass:[UITabBarController class]] || [tempController isKindOfClass:[UISplitViewController class]] || [tempController isKindOfClass:[UISplitHackController class]]) {
        if ([tempController isKindOfClass:[UINavigationController class]]) {
            tempController = ((UINavigationController *)tempController).topViewController;
        } else if ([tempController isKindOfClass:[UITabBarController class]]) {
            tempController = ((UITabBarController *)tempController).selectedViewController;
        } else if ([tempController isKindOfClass:[UISplitViewController class]]) {
            tempController = ((UIViewController *)((UISplitViewController *)tempController).delegate);
        } else if ([tempController isKindOfClass:[UISplitHackController class]]) {
            tempController = ((UISplitHackController *)tempController).splitController;
        }
    }
    [tempController proceedToNextViewControllerWithTransition:type];
}

- (void)setFlowController:(CGFlowController *)flowCon
{
    objc_setAssociatedObject(self, &flowKey, flowCon, OBJC_ASSOCIATION_ASSIGN);
    for (UIViewController *childController in self.childViewControllers) {
        [childController setFlowController:flowCon];
    }
}

- (CGFlowController *)flowController
{
    CGFlowController *flowCon = objc_getAssociatedObject(self, &flowKey);
    UIViewController *parent = self.parentViewController;
    while (parent && !flowCon) {
        flowCon = parent.flowController;
        parent = parent.parentViewController;
    }
    return flowCon;
}

- (void)setTransitioning:(BOOL)transition
{
    NSNumber *number = [NSNumber numberWithBool:transition];
    objc_setAssociatedObject(self, &transitioningKey, number, OBJC_ASSOCIATION_RETAIN);
    if ([self isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)self).topViewController setTransitioning:transition];
    }
}

- (BOOL)transitioning
{
    NSNumber *number = objc_getAssociatedObject(self, &transitioningKey);
    return [number boolValue];
}

- (void)setLowestLevel:(BOOL)lowest
{
    NSNumber *number = [NSNumber numberWithBool:lowest];
    objc_setAssociatedObject(self, &lowestLevelKey, number, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)lowestLevel
{
    NSNumber *number = objc_getAssociatedObject(self, &lowestLevelKey);
    return [number boolValue];
}

@end
