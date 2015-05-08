//
//  GADetailNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADetailNavigationController.h"

@interface GADetailNavigationController ()

@end

@implementation GADetailNavigationController

#pragma mark - Constructors

+ (instancetype)new {
    GADiaporamaVC *rootVC = [GADiaporamaVC new];
    GADetailNavigationController *navVC = [[GADetailNavigationController alloc] initWithRootViewController:rootVC];
    navVC.navigationBar.translucent = NO;
    return navVC;
}

#pragma mark - Getters & Setters

- (GADiaporamaVC *)rootViewController {
    return (GADiaporamaVC *)[self.viewControllers firstObject];
}

@end
