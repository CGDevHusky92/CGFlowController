//
//  DetailViewController.h
//  Split
//
//  Created by Charles Gorectke on 1/9/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGFlowController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, strong) id detailItem;
@end
