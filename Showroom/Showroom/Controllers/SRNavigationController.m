//
//  SRNavigationController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 20/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRNavigationController.h"

@implementation SRNavigationController

- (void)loadView {
    [super loadView];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.12f green:0.45f blue:0.66f alpha:1.00f];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
}

@end
