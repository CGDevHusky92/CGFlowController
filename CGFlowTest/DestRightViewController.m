//
//  DestViewController.m
//  CGFlowAnimationDemo
//
//  Created by Chase Gorectke on 12/18/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import "DestRightViewController.h"
#import "SrcViewController.h"

@interface DestRightViewController()
-(IBAction)moveToSrc:(id)sender;
@end

@implementation DestRightViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(IBAction)moveToSrc:(id)sender {
    UIViewController *srcController = [self.storyboard instantiateViewControllerWithIdentifier:@"CGFlowInitialScene"];
    [self.flowController flowToViewController:srcController withAnimation:kCGFlowAnimationFlipRight andDuration:0.4 completion:^(BOOL finished){}];
}

#pragma mark - CGInteractiveTransitionDelegate methods

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
    if (type == kCGFlowInteractionSwipeRight) {
        UIViewController *srcController = [self.storyboard instantiateViewControllerWithIdentifier:@"CGFlowInitialScene"];
        [self.flowController flowInteractivelyToViewController:srcController withAnimation:kCGFlowAnimationFlipRight completion:^(BOOL finished){}];
    }
}

#pragma mark - Memory Protocol

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
