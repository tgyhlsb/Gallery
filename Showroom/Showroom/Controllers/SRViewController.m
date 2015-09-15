//
//  SRViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 11/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRViewController.h"

// Managers
#import "SRAnalyticsManager.h"

@implementation SRViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SRAnalyticsManager addScreenView:self.screenName];
}

@end
