//
//  DestViewController.m
//  CGFlowAnimationDemo
//
//  Created by Chase Gorectke on 12/18/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import "DestLeftViewController.h"
#import "SrcViewController.h"

@interface DestLeftViewController()
-(IBAction)moveToSrc:(id)sender;
@end

@implementation DestLeftViewController

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
    [self.flowController flowToViewController:srcController withAnimation:kCGFlowAnimationFlipLeft andDuration:0.4 completion:^(BOOL finished){}];
}

#pragma mark - CGInteractiveTransitionDelegate methods

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
    if (type == kCGFlowInteractionSwipeLeft) {
        UIViewController *srcController = [self.storyboard instantiateViewControllerWithIdentifier:@"CGFlowInitialScene"];
        [self.flowController flowInteractivelyToViewController:srcController withAnimation:kCGFlowAnimationFlipLeft completion:^(BOOL finished){}];
    }
}

#pragma mark - Memory Protocol

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
