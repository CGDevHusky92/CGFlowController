//
//  ViewController.m
//  CGFlowAnimationDemo
//
//  Created by Chase Gorectke on 12/18/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import "SrcViewController.h"
#import "CGFlowSegue.h"

@interface SrcViewController()

@end

@implementation SrcViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.unloadInteractor = [CGFlowAnimation new];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.unloadInteractor) {
        [self.unloadInteractor setDelegate:self withOptions:kCGFlowInteractionMainPan];
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - CGInteractiveTransitionDelegate methods

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
    if (type == kCGFlowInteractionSwipeLeft) {
        [self.unloadInteractor setAnimationType:kCGFlowAnimationFlipLeft];
        [self performSegueWithIdentifier:@"srcRightSegue" sender:self];
    } else if (type == kCGFlowInteractionSwipeRight) {
        [self.unloadInteractor setAnimationType:kCGFlowAnimationFlipRight];
        [self performSegueWithIdentifier:@"srcLeftSegue" sender:self];
    } else if (type == kCGFlowInteractionSwipeUp) {
        [self.unloadInteractor setAnimationType:kCGFlowAnimationFlipUp];
        [self performSegueWithIdentifier:@"srcBottomSegue" sender:self];
    } else if (type == kCGFlowInteractionSwipeDown) {
        [self.unloadInteractor setAnimationType:kCGFlowAnimationFlipDown];
        [self performSegueWithIdentifier:@"srcTopSegue" sender:self];
    }
}

#pragma mark - Segue Protocol

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /* Whenever using CGFlowAnimation it is absolutely necessary to use the super call */
    [super prepareForSegue:segue sender:sender];
}

-(IBAction)unwindSegueSrc:(UIStoryboardSegue *)segue {
    
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"srcRightUnwind"]) {
        CGFlowSegue *segue = [[CGFlowSegueFlipLeft alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        [segue setDismiss:YES];
        toViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        return segue;
    } else if ([identifier isEqualToString:@"srcLeftUnwind"]) {
        CGFlowSegue *segue = [[CGFlowSegueFlipRight alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        [segue setDismiss:YES];
        return segue;
    } else if ([identifier isEqualToString:@"srcTopUnwind"]) {
        CGFlowSegue *segue = [[CGFlowSegueFlipDown alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        [segue setDismiss:YES];
        return segue;
    } else if ([identifier isEqualToString:@"srcBottomUnwind"]) {
        CGFlowSegue *segue = [[CGFlowSegueFlipUp alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        [segue setDismiss:YES];
        return segue;
    }
    return nil;
}

#pragma mark - Memory Protocol

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
