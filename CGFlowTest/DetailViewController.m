//
//  DetailViewController.m
//  Split
//
//  Created by Charles Gorectke on 1/9/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController()
-(void)configureView;
@end

@implementation DetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (self.navigationController.parentViewController && [self.navigationController.parentViewController isKindOfClass:[UISplitViewController class]]) {
            [((UISplitViewController *)self.navigationController.parentViewController) setDelegate:self];
        }
    }
    
    [self configureView];
}

#pragma mark - Detail Methods

-(void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

-(void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

#pragma mark - Split View Delegate

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

#pragma mark - CGInteractiveTransitionDelegate methods

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
    UIViewController *destController;
    if (type == kCGFlowInteractionSwipeUp) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destBottomController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationFlipUp completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionSwipeDown) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destTopController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationSlideDown completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionSwipeLeft) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destRightController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationSlideLeft completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionSwipeRight) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destLeftController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationSlideRight completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionPinchIn) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destRightController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationSlideLeft completion:^(BOOL finished){}];
    } else if (type == kCGFlowInteractionPinchOut) {
        destController = [self.storyboard instantiateViewControllerWithIdentifier:@"destLeftController"];
        [self.flowController flowInteractivelyToViewController:destController withAnimation:kCGFlowAnimationSlideRight completion:^(BOOL finished){}];
    }
}

#pragma mark - Memory Methods

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
