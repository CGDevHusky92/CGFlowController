//
//  MasterViewController.h
//  Split
//
//  Created by Charles Gorectke on 1/9/14.
//  Copyright (c) 2014 Charles Gorectke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@interface MasterViewController : UITableViewController
@property (strong, nonatomic) DetailViewController *detailViewController;
@end
