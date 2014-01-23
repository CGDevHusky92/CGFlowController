//
//  CGFlowController.m
//  CGFlowTest
//
//  Created by Charles Gorectke on 1/4/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import "CGFlowController.h"
#import "objc/runtime.h"

#define willDidMove
#define appearanceTransition

@interface CGFlowController()
@property (nonatomic, strong) CGFlowInteractor *interactor;
@property (nonatomic, assign) Completion currentCompletion;
@property (nonatomic, assign) kCGFlowAnimationType animationType;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL started;
@end

@implementation CGFlowController

-(void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _started = false;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.definesPresentationContext = YES;
    self.providesPresentationContextTransitionStyle = YES;
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
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_started) {
        self.flowedController.transitioning = YES;
        [self.flowedController beginAppearanceTransition:YES animated:NO];
        self.flowedController.transitioning = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if (!_started) {
        _started = true;
        self.flowedController.transitioning = YES;
        [self.flowedController endAppearanceTransition];
        self.flowedController.transitioning = NO;
    }
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


-(void)flowToViewController:(UIViewController *)viewController withAnimation:(kCGFlowAnimationType)animation completion:(Completion)completion {
    BOOL animated = YES;
    if (animation == kCGFlowAnimationNone) {
        animated = NO;
    }
    
    UIViewController *tempController = viewController;
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitHackController *splitController = [[UISplitHackController alloc] init];
        [splitController setSplitController:(UISplitViewController *)viewController];
        tempController = (UIViewController *)splitController;
    }
    
    tempController.transitioning = YES;
    [tempController viewWillAppear:animated];
    tempController.transitioning = NO;
    
    self.flowedController.transitioning = YES;
    [self.flowedController beginAppearanceTransition:NO animated:animated];
    self.flowedController.transitioning = NO;
    
    tempController.transitioningDelegate = self;
    tempController.modalPresentationStyle = UIModalPresentationCustom;
    _animationType = animation;
    self.interactive = NO;
    _currentCompletion = completion;
    [self.flowedController presentViewController:tempController animated:animated completion:^{}];
}

-(void)flowInteractivelyToViewController:(UIViewController *)viewController withAnimation:(kCGFlowAnimationType)animation completion:(Completion)completion {
    BOOL animated = YES;
    if (animation == kCGFlowAnimationNone) {
        animated = NO;
    }
    
    UIViewController *tempController = viewController;
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitHackController *splitController = [[UISplitHackController alloc] init];
        [splitController setSplitController:(UISplitViewController *)viewController];
        tempController = (UIViewController *)splitController;
    }
    
    tempController.transitioning = YES;
    [tempController viewWillAppear:animated];
    tempController.transitioning = NO;
    
    self.flowedController.transitioning = YES;
    [self.flowedController viewWillDisappear:animated];
    self.flowedController.transitioning = NO;
    
    tempController.transitioningDelegate = self;
    tempController.modalPresentationStyle = UIModalPresentationCustom;
    _animationType = animation;
    self.interactive = YES;
    _currentCompletion = completion;
    
    [self.flowedController presentViewController:tempController animated:animated completion:^{}];
}

-(void)setFlowedController:(UIViewController<CGFlowInteractiveDelegate> *)flowedController {
    _flowedController = flowedController;
    [self.flowedController setFlowController:self];
    _flowedController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

-(void)startTransition:(UIViewController *)vc {
    [self.flowedController willMoveToParentViewController:nil];
}

-(void)cancelTransition:(UIViewController *)vc {
    self.interactive = NO;
    [vc setTransitioningDelegate:nil];
    [self.flowedController dismissViewControllerAnimated:NO completion:^{
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }];
}

-(void)finishTransition:(UIViewController *)vc {
    vc.transitioning = YES;
    [vc viewDidAppear:YES];
    vc.transitioning = NO;
    
    self.interactive = NO;
    __weak __block UIViewController *tempVc; // = vc;
    if ([vc isKindOfClass:[UISplitHackController class]]) {
        tempVc = ((UISplitHackController *)vc).splitController;
    } else {
        tempVc = vc;
    }
    
    __weak __block CGFlowController *safeSelf = self;
    [self.flowedController dismissViewControllerAnimated:NO completion:^{
        [tempVc willMoveToParentViewController:nil];
        [tempVc.view removeFromSuperview];
        [tempVc removeFromParentViewController];
        
        [safeSelf addChildViewController:tempVc];
        [safeSelf.view addSubview:tempVc.view];
        
        [safeSelf.flowedController setTransitioningDelegate:nil];
        [safeSelf.flowedController.view removeFromSuperview];
        
        safeSelf.flowedController.transitioning = YES;
        [safeSelf.flowedController viewDidDisappear:YES];
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
        }];
    }];
}

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
    [self.flowedController proceedToNextViewControllerWithTransition:type];
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    CGFlowAnimation *animator = [CGFlowAnimation new];
    animator.animationType = _animationType;
    animator.interactive = _interactive;
    [animator setFlowController:self];
    return animator;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    CGFlowAnimation *animator = [CGFlowAnimation new];
    animator.animationType = _animationType;
    animator.interactive = _interactive;
    [animator setFlowController:self];
    return animator;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (_interactive) {
        return self.interactor;
    }
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (_interactive) {
        return self.interactor;
    }
    return nil;
}

#pragma mark - Memory Methods

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface CGFlowAnimation()

@end

@implementation CGFlowAnimation
@synthesize animationType=_animationType;
@synthesize interactive=_interactive;

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

#pragma mark - UIViewControllerAnimatedTransitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [toVC.view removeFromSuperview];
    [self.flowController startTransition:toVC];
    toVC.view.bounds = fromVC.view.bounds;
    [containerView addSubview:toVC.view];
    
    if (self.animationType == kCGFlowAnimationFlipUp) {
        // Set the frames
        NSLog(@"Flipping Up");
        fromVC.view.frame = containerView.bounds;
        toVC.view.frame = containerView.bounds;
        
        // Start building the transform - 3D so need perspective
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1 / CGRectGetHeight(containerView.bounds);
        containerView.layer.sublayerTransform = transform;
        
        toVC.view.layer.transform = CATransform3DMakeRotation(-1.0 * M_PI_2, 1, 0, 0);
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            // First half is rotating in
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                fromVC.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                toVC.view.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
            }];
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:YES];
                if ([transitionContext transitionWasCancelled]) {
                    [self.flowController cancelTransition:toVC];
                } else {
                    [self.flowController finishTransition:toVC];
                }
            }
        }];
    } else {
        [CGFlowAnimations flowAnimation:self.animationType fromSource:fromVC toDestination:toVC withContainer:containerView andDuration:[self transitionDuration:transitionContext] withOrientation:[fromVC interfaceOrientation] interactively:_interactive completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:YES];
                if ([transitionContext transitionWasCancelled]) {
                    [self.flowController cancelTransition:toVC];
                } else {
                    [self.flowController finishTransition:toVC];
                }
            }
        }];
    }
}

@end

@interface CGFlowInteractor() <UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) UIScreenEdgePanGestureRecognizer *edgeGesture;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong, readwrite) UILongPressGestureRecognizer *pressGesture;
@property (nonatomic, strong, readwrite) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong, readwrite) UIRotationGestureRecognizer *rotateGesture;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) kCGFlowInteractionType interactorType;
@end

@implementation CGFlowInteractor

-(void)setFlowController:(CGFlowController *)flowController {
    _flowController = flowController;
    _interactorType = kCGFlowInteractionNone;
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UILongPressGestureRecognizer *longDoubleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UILongPressGestureRecognizer *longTripleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIScreenEdgePanGestureRecognizer *edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *singleDoubleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *doubleDoubleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *tripleDoubleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *singleTripleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *doubleTripleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    UITapGestureRecognizer *tripleTripleTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleGesture:)];
    
    [longGesture setCancelsTouchesInView:NO];
    [longDoubleGesture setCancelsTouchesInView:NO];
    [longTripleGesture setCancelsTouchesInView:NO];
    [panGesture setCancelsTouchesInView:NO];
    [edgeGesture setCancelsTouchesInView:NO];
    [pinchGesture setCancelsTouchesInView:NO];
    [rotationGesture setCancelsTouchesInView:NO];
    
    [singleTapGesture setCancelsTouchesInView:NO];
    [doubleTapGesture setCancelsTouchesInView:NO];
    [tripleTapGesture setCancelsTouchesInView:NO];
    [singleDoubleTapGesture setCancelsTouchesInView:NO];
    [doubleDoubleTapGesture setCancelsTouchesInView:NO];
    [tripleDoubleTapGesture setCancelsTouchesInView:NO];
    [singleTripleTapGesture setCancelsTouchesInView:NO];
    [doubleTripleTapGesture setCancelsTouchesInView:NO];
    [tripleTripleTapGesture setCancelsTouchesInView:NO];
    
    [longGesture setMinimumPressDuration:1.5];
    [longDoubleGesture setMinimumPressDuration:1.5];
    [longTripleGesture setMinimumPressDuration:1.5];
    
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture setNumberOfTouchesRequired:1];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setNumberOfTouchesRequired:1];
    [tripleTapGesture setNumberOfTapsRequired:3];
    [tripleTapGesture setNumberOfTouchesRequired:1];
    [singleDoubleTapGesture setNumberOfTapsRequired:1];
    [singleDoubleTapGesture setNumberOfTouchesRequired:2];
    [doubleDoubleTapGesture setNumberOfTapsRequired:2];
    [doubleDoubleTapGesture setNumberOfTouchesRequired:2];
    [tripleDoubleTapGesture setNumberOfTapsRequired:3];
    [tripleDoubleTapGesture setNumberOfTouchesRequired:2];
    [singleTripleTapGesture setNumberOfTapsRequired:1];
    [singleTripleTapGesture setNumberOfTouchesRequired:3];
    [doubleTripleTapGesture setNumberOfTapsRequired:2];
    [doubleTripleTapGesture setNumberOfTouchesRequired:3];
    [tripleTripleTapGesture setNumberOfTapsRequired:3];
    [tripleTripleTapGesture setNumberOfTouchesRequired:3];
    
    [edgeGesture requireGestureRecognizerToFail:panGesture];
    [longGesture requireGestureRecognizerToFail:longDoubleGesture];
    [longGesture requireGestureRecognizerToFail:longTripleGesture];
    [longDoubleGesture requireGestureRecognizerToFail:longTripleGesture];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [singleTapGesture requireGestureRecognizerToFail:tripleTapGesture];
    [doubleTapGesture requireGestureRecognizerToFail:tripleTapGesture];
    [singleDoubleTapGesture requireGestureRecognizerToFail:doubleDoubleTapGesture];
    [singleDoubleTapGesture requireGestureRecognizerToFail:tripleDoubleTapGesture];
    [doubleDoubleTapGesture requireGestureRecognizerToFail:tripleDoubleTapGesture];
    [singleTripleTapGesture requireGestureRecognizerToFail:doubleTripleTapGesture];
    [singleTripleTapGesture requireGestureRecognizerToFail:tripleTripleTapGesture];
    [doubleTripleTapGesture requireGestureRecognizerToFail:tripleTripleTapGesture];
    
    [_flowController.view addGestureRecognizer:longGesture];
    [_flowController.view addGestureRecognizer:longDoubleGesture];
    [_flowController.view addGestureRecognizer:longTripleGesture];
    [_flowController.view addGestureRecognizer:panGesture];
    [_flowController.view addGestureRecognizer:edgeGesture];
    [_flowController.view addGestureRecognizer:pinchGesture];
    [_flowController.view addGestureRecognizer:rotationGesture];
    [_flowController.view addGestureRecognizer:singleTapGesture];
    [_flowController.view addGestureRecognizer:doubleTapGesture];
    [_flowController.view addGestureRecognizer:tripleTapGesture];
    [_flowController.view addGestureRecognizer:singleDoubleTapGesture];
    [_flowController.view addGestureRecognizer:doubleDoubleTapGesture];
    [_flowController.view addGestureRecognizer:tripleDoubleTapGesture];
    [_flowController.view addGestureRecognizer:singleTripleTapGesture];
    [_flowController.view addGestureRecognizer:doubleTripleTapGesture];
    [_flowController.view addGestureRecognizer:tripleTripleTapGesture];
}

#pragma mark - Gesture Handler

-(void)handleGesture:(UIGestureRecognizer *)gr {
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


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

#pragma mark - UISplitHackController

@implementation UISplitHackController
@synthesize splitController=_splitController;
-(void)setSplitController:(UISplitViewController *)splitController {
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

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
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

-(void)setFlowController:(CGFlowController *)flowCon {
    objc_setAssociatedObject(self, &flowKey, flowCon, OBJC_ASSOCIATION_ASSIGN);
    for (UIViewController *childController in self.childViewControllers) {
        [childController setFlowController:flowCon];
    }
}

-(CGFlowController *)flowController {
    CGFlowController *flowCon = objc_getAssociatedObject(self, &flowKey);
    UIViewController *parent = self.parentViewController;
    while (parent && !flowCon) {
        flowCon = parent.flowController;
        parent = parent.parentViewController;
    }
    return flowCon;
}

-(void)setTransitioning:(BOOL)transition {
    NSNumber *number = [NSNumber numberWithBool:transition];
    objc_setAssociatedObject(self, &transitioningKey, number, OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)transitioning {
    NSNumber *number = objc_getAssociatedObject(self, &transitioningKey);
    return [number boolValue];
}

-(void)setLowestLevel:(BOOL)lowest {
    NSNumber *number = [NSNumber numberWithBool:lowest];
    objc_setAssociatedObject(self, &lowestLevelKey, number, OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)lowestLevel {
    NSNumber *number = objc_getAssociatedObject(self, &lowestLevelKey);
    return [number boolValue];
}

@end
