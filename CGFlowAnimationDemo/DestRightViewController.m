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

@end

@implementation DestRightViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    // Set the recipeint of the interactor
    if (self.loadInteractor) {
        [self.loadInteractor setDelegate:self withOptions:kCGFlowInteractionMainPan];
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - CGInteractiveTransitionDelegate methods

-(void)proceedToNextViewControllerWithTransition:(kCGFlowInteractionType)type {
    if (type == kCGFlowInteractionSwipeRight) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - Segue Protocol

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - Memory Protocol

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
