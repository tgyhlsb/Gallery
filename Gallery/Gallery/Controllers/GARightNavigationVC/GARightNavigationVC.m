//
//  GARightNavigationVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GARightNavigationVC.h"

@interface GARightNavigationVC ()

@end

@implementation GARightNavigationVC

#pragma mark - Constructors

+ (instancetype)new {
    GADiaporamaVC *rootVC = [GADiaporamaVC new];
    GARightNavigationVC *navVC = [[GARightNavigationVC alloc] initWithRootViewController:rootVC];
    navVC.navigationBar.translucent = NO;
    return navVC;
}

#pragma mark - Getters & Setters

- (GADiaporamaVC *)rootViewController {
    return (GADiaporamaVC *)[self.viewControllers firstObject];
}

@end
