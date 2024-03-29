//
//  SRSelectionPopoverNavigationController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRSelectionPopoverNavigationController : UINavigationController

@property (copy) void (^closeBlock)(void);

- (void)setCloseBlock:(void (^)(void))closeBlock;

@end
