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

@property (nonatomic, strong) NSMutableDictionary *liveControllerDic;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) CGFlowInteractor *interactor;
@property (nonatomic, assign) CGFlowAnimationType animationType;
@property (nonatomic, assign) CGFlowAnimationType modalTapDismissAnimation;
@property (nonatomic, assign) Completion modalTapCompletion;
@property (nonatomic, assign) Completion currentCompletion;

//@property (assign) CGPoint modalScale;
@property (assign) CGFloat duration;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL started;

@end

@implementation CGFlowController

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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.flowedController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"CGFlowInitialScene"];
    } else {
        self.flowedController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"CGFlowInitialScene"];
    }
    
    if (_flowedController) {
        [self addChildViewController:_flowedController];
        _flowedController.view.frame = self.view.bounds;
        [self.view addSubview:_flowedController.view];
        [self.flowedController didMoveToParentViewController:self];
        _flowedController.flowController = self;
        _statusController = _flowedController;
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

- (void)flowModalViewWillAppear:(BOOL)animated
{
    if (_modalController) {
        if ([_modalController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)self.modalController).topViewController setTransitioning:YES];
            [((UINavigationController *)self.modalController).topViewController viewWillAppear:animated];
            [((UINavigationController *)self.modalController).topViewController setTransitioning:NO];
        }
    }
}

- (void)flowModalViewDidAppear:(BOOL)animated
{
    if (_modalController) {
        if ([_modalController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)self.modalController).topViewController setTransitioning:YES];
            [((UINavigationController *)self.modalController).topViewController viewDidAppear:animated];
            [((UINavigationController *)self.modalController).topViewController setTransitioning:NO];
        }
    }
}

- (void)flowModalViewWillDisappear:(BOOL)animated
{
    if (_modalController) {
        if ([_modalController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)self.modalController).topViewController setTransitioning:YES];
            [((UINavigationController *)self.modalController).topViewController viewWillDisappear:animated];
            [((UINavigationController *)self.modalController).topViewController setTransitioning:NO];
        }
    }
}

- (void)flowModalViewDidDisappear:(BOOL)animated
{
    if (_modalController) {
        if ([_modalController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)self.modalController).topViewController setTransitioning:YES];
            [((UINavigationController *)self.modalController).topViewController viewDidDisappear:animated];
            [((UINavigationController *)self.modalController).topViewController setTransitioning:NO];
        }
    }
}

#pragma mark - Flow To Base Controller Transitions

- (void)viewWillAppearCall:(UIViewController *)controller animated:(BOOL)animated
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)controller).topViewController viewWillAppear:animated];
    } else {
        [controller viewWillAppear:animated];
    }
}

- (void)viewWillDisappearCall:(UIViewController *)controller animated:(BOOL)animated
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)controller).topViewController viewWillDisappear:animated];
    } else {
        [controller viewWillDisappear:animated];
    }
}

- (void)viewDidAppearCall:(UIViewController *)controller animated:(BOOL)animated
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)controller).topViewController viewDidAppear:animated];
    } else {
        [controller viewDidAppear:animated];
    }
}

- (void)viewDidDisappearCall:(UIViewController *)controller animated:(BOOL)animated
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)controller).topViewController viewDidDisappear:animated];
    } else {
        [controller viewDidDisappear:animated];
    }
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
    BOOL animated = !(animation == kCGFlowAnimationNone);
    
    _statusController = viewController;
    UIViewController *tempController = viewController;
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitHackController *splitController = [[UISplitHackController alloc] init];
        [splitController setSplitController:(UISplitViewController *)viewController];
        tempController = (UIViewController *)splitController;
    }
    
    if (interactive) {
        tempController.transitioning = YES;
        [tempController viewWillAppear:animated];
        tempController.transitioning = NO;
        
        self.flowedController.transitioning = YES;
        [self.flowedController viewWillDisappear:animated];
        self.flowedController.transitioning = NO;
        self.interactive = YES;
    } else {
        tempController.transitioning = YES;
        [self viewWillAppearCall:tempController animated:animated];
        tempController.transitioning = NO;
        
        self.flowedController.transitioning = YES;
        [self viewWillDisappearCall:self.flowedController animated:animated];
        self.flowedController.transitioning = NO;
        
        _duration = duration;
        self.interactive = NO;
    }
    
    tempController.transitioningDelegate = self;
    tempController.modalPresentationStyle = UIModalPresentationFullScreen;
    _animationType = animation;
    _currentCompletion = completion;
    [self.flowedController presentViewController:tempController animated:animated completion:^{}];
}

- (void)startTransition:(UIViewController *)vc
{
    [self.flowedController willMoveToParentViewController:nil];
}

- (void)cancelTransition:(UIViewController *)vc
{
    _statusController = _flowedController;
    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.interactive = NO;
    [vc setTransitioningDelegate:nil];
    [self.flowedController dismissViewControllerAnimated:NO completion:^{
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        _currentCompletion(NO);
    }];
}

- (void)finishTransition:(UIViewController *)vc
{
    vc.transitioning = YES;
    [self viewDidAppearCall:vc animated:YES];
    vc.transitioning = NO;
    
    self.interactive = NO;
    __weak __block UIViewController *tempVc;
    if ([vc isKindOfClass:[UISplitHackController class]]) {
        tempVc = ((UISplitHackController *)vc).splitController;
    } else {
        tempVc = vc;
    }
    
    __weak __block CGFlowController *safeSelf = self;
    [self.flowedController dismissViewControllerAnimated:NO completion:^{
        [safeSelf addChildViewController:tempVc];
        [safeSelf.view addSubview:tempVc.view];
        
        [safeSelf.flowedController setTransitioningDelegate:nil];
        [safeSelf.flowedController.view removeFromSuperview];
        
        safeSelf.flowedController.transitioning = YES;
        [safeSelf viewDidDisappearCall:safeSelf.flowedController animated:YES];
        safeSelf.flowedController.transitioning = NO;
        
        [safeSelf.flowedController removeFromParentViewController];
        safeSelf.flowedController = tempVc;
        safeSelf.flowedController.flowController = safeSelf;
        [safeSelf.flowedController didMoveToParentViewController:safeSelf];
        
        // Important to reset all the bounds and frame after completion
        [UIView animateWithDuration:0.0 animations:^{
            [safeSelf.view setBounds:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
            [safeSelf.flowedController.view setBounds:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
            [safeSelf.view setFrame:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
            [safeSelf.flowedController.view setFrame:CGRectMake(0, 0, safeSelf.view.window.bounds.size.width, safeSelf.view.window.bounds.size.height)];
        } completion:_currentCompletion];
    }];
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
    viewController.transitioning = YES;
    [viewController viewWillAppear:YES];
    viewController.transitioning = NO;
    
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
        _modalController.transitioning = YES;
        [_modalController viewWillDisappear:YES];
        _modalController.transitioning = NO;
        
        _modalController.transitioningDelegate = self;
        _modalController.modalPresentationStyle = UIModalPresentationCustom;
        _animationType = animation;
        _interactive = interactive;
        
        _currentCompletion = completion;
        [self dismissViewControllerAnimated:YES completion:^{}];
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
        
        safeSelf.modalController.transitioning = YES;
        [safeSelf viewDidDisappearCall:safeSelf.modalController animated:YES];
        safeSelf.modalController.transitioning = NO;
        
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
        self.modalController.transitioning = YES;
        [self.modalController viewDidAppear:YES];
        self.modalController.transitioning = NO;
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

#pragma mark - Appearence Callback Forwarding ??? Doesn't seem to work

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

#pragma mark - UIStatusBar

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return _statusController;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    CGFlowAnimation *animator = [CGFlowAnimation new];
    animator.animationType = _animationType;
    animator.duration = _duration;
    if (_duration != 0.4) {
        _duration = 0.4;
    }
    animator.interactive = _interactive;
    [animator setFlowController:self];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    CGFlowAnimation *animator = [CGFlowAnimation new];
    animator.animationType = _animationType;
    animator.interactive = _interactive;
    animator.duration = _duration;
    if (_duration != 0.4) {
        _duration = 0.4;
    }
    [animator setFlowController:self];
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (_interactive) {
        return self.interactor;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (_interactive) {
        return self.interactor;
    }
    return nil;
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

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
            [transitionContext completeTransition:YES];
            if ([transitionContext transitionWasCancelled]) {
                
//                NSLog(@"Cancelled");
                if (cat == kCGFlowCategory2DAnimation || cat == kCGFlowCategory3DAnimation) {
//
//                    [transitionContext completeTransition:YES];
                    [self.flowController cancelTransition:destination.viewController];
//                    
                } else {
                    
//                    [transitionContext completeTransition:NO];
//                    [self.flowController cancelTransition:destination.viewController];
                    [self.flowController cancelPanelTransition:source.viewController];
                    
                }
            
            } else {
                
//                [transitionContext completeTransition:YES];
                if (cat == kCGFlowCategoryModalPresent || cat == kCGFlowCategoryPanelPresent) {
                    [self.flowController finishTransitionModal:destination.viewController appearing:YES];
                } else if (cat == kCGFlowCategoryModalDismiss || cat == kCGFlowCategoryPanelDismiss) {
                    [self.flowController finishTransitionModal:destination.viewController appearing:NO];
                } else {
                    [self.flowController finishTransition:destination.viewController];
                }
                
            }
        }
    }];
}

@end

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
                    self.completionSpeed = 0.5f;
                    [self cancelInteractiveTransition];
                } else {
                    self.completionSpeed = 1.0f;
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
                    self.completionSpeed = 0.5f;
                    [self cancelInteractiveTransition];
                } else {
                    self.completionSpeed = 1.0f;
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
