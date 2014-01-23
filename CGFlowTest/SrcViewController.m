//
//  ViewController.m
//  CGFlowAnimationDemo
//
//  Created by Chase Gorectke on 12/18/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import "SrcViewController.h"

@interface SrcViewController()
-(IBAction)moveToDestTop:(id)sender;
-(IBAction)moveToDestBottom:(id)sender;
-(IBAction)moveToDestLeft:(id)sender;
-(IBAction)moveToDestRight:(id)sender;
@end

@implementation SrcViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.transitioning) {
        [super viewWillAppear:animated];
//        BOOL anTruth = NO;
//        if (self.isBeingPresented) {
//            anTruth = YES;
//            NSLog(@"viewWillAppear - isBeingPresented");
//        }
//        if (self.isBeingDismissed) {
//            anTruth = YES;
//            NSLog(@"viewWillAppear - isBeingDismissed");
//        }
//        if (self.isMovingToParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewWillAppear - isMovingToParentViewController");
//        }
//        if (self.isMovingFromParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewWillAppear - isMovingFromParentViewController");
//        }
//        if (!anTruth) {
            NSLog(@"viewWillAppear");
//        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.transitioning) {
//        BOOL anTruth = NO;
//        if (self.isBeingPresented) {
//            anTruth = YES;
//            NSLog(@"viewDidAppear - isBeingPresented");
//        }
//        if (self.isBeingDismissed) {
//            anTruth = YES;
//            NSLog(@"viewDidAppear - isBeingDismissed");
//        }
//        if (self.isMovingToParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewDidAppear - isMovingToParentViewController");
//        }
//        if (self.isMovingFromParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewDidAppear - isMovingFromParentViewController");
//        }
//        if (!anTruth) {
            NSLog(@"viewDidAppear");
//        }
        [super viewDidAppear:animated];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    if (self.transitioning) {
        [super viewWillDisappear:animated];
//        BOOL anTruth = NO;
//        if (self.isBeingPresented) {
//            anTruth = YES;
//            NSLog(@"viewWillDisappear - isBeingPresented");
//        }
//        if (self.isBeingDismissed) {
//            anTruth = YES;
//            NSLog(@"viewWillDisappear - isBeingDismissed");
//        }
//        if (self.isMovingToParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewWillDisappear - isMovingToParentViewController");
//        }
//        if (self.isMovingFromParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewWillDisappear - isMovingFromParentViewController");
//        }
//        if (!anTruth) {
            NSLog(@"viewWillDisappear");
//        }
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    if (self.transitioning) {
//        BOOL anTruth = NO;
//        if (self.isBeingPresented) {
//            anTruth = YES;
//            NSLog(@"viewDidDisappear - isBeingPresented");
//        }
//        if (self.isBeingDismissed) {
//            anTruth = YES;
//            NSLog(@"viewDidDisappear - isBeingDismissed");
//        }
//        if (self.isMovingToParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewDidDisappear - isMovingToParentViewController");
//        }
//        if (self.isMovingFromParentViewController) {
//            anTruth = YES;
//            NSLog(@"viewDidDisappear - isMovingFromParentViewController");
//        }
//        if (!anTruth) {
            NSLog(@"viewDidDisappear");
//        }
        [super viewDidDisappear:animated];
    }
}

#pragma mark - Button Methods

-(IBAction)moveToDestTop:(id)sender {
    UIViewController *destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destTopController"];
    [self.flowController flowToViewController:destController withAnimation:kCGFlowAnimationSlideDown completion:^(BOOL finished){}];
}

-(IBAction)moveToDestBottom:(id)sender {
    UIViewController *destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destBottomController"];
    [self.flowController flowToViewController:destController withAnimation:kCGFlowAnimationSlideUp completion:^(BOOL finished){}];
}

-(IBAction)moveToDestLeft:(id)sender {
    UIViewController *destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destLeftController"];
    [self.flowController flowToViewController:destController withAnimation:kCGFlowAnimationFlipRight completion:^(BOOL finished){}];
}

-(IBAction)moveToDestRight:(id)sender {
    UIViewController *destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destRightController"];
    [self.flowController flowToViewController:destController withAnimation:kCGFlowAnimationFlipLeft completion:^(BOOL finished){}];
}

#pragma mark - CGInteractiveTransitionDelegate methods

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
    UIViewController *destController;
    if (type == kCGFlowInteractionSwipeUp) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destBottomController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationFlipUp completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionSwipeDown) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destTopController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationFlipDown completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionSwipeLeft) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destRightController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationFlipLeft completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionSwipeRight) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destLeftController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationFlipRight completion:^(BOOL finished){}];
    }
}

#pragma mark - Memory Protocol

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
