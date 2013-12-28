//
//  CGFlowSegue.h
//  CGFlowAnimationDemo
//
//  Created by Chase Gorectke on 12/22/13.
//  Copyright (c) 2013 Revision Works, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGFlowSegue : UIStoryboardSegue
@property (assign) BOOL dismiss;
@end

@interface CGFlowSegueNoAnimation : CGFlowSegue
@end

@interface CGFlowSegueFlipUp : CGFlowSegue
@end

@interface CGFlowSegueFlipDown : CGFlowSegue
@end

@interface CGFlowSegueSlideLeft : CGFlowSegue
@end

@interface CGFlowSegueSlideRight : CGFlowSegue
@end
