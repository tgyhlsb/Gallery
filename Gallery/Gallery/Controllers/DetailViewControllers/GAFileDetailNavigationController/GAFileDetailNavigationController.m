//
//  GAFileDetailNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFileDetailNavigationController.h"

@interface GAFileDetailNavigationController ()

@end

@implementation GAFileDetailNavigationController

#pragma mark - Constructors

+ (instancetype)newWithDirectory:(GADirectory *)directory {
    GADiaporamaVC *rootVC = [GADiaporamaVC newWithFiles:directory.images andSelectedImageFile:nil];
    rootVC.showSplitButton = YES;
    GAFileDetailNavigationController *navVC = [[GAFileDetailNavigationController alloc] initWithRootViewController:rootVC];
    navVC.navigationBar.translucent = NO;
    navVC.toolbarHidden = NO;
    navVC.toolbar.translucent = NO;
    return navVC;
}

#pragma mark - Getters & Setters

- (GADiaporamaVC *)rootViewController {
    return (GADiaporamaVC *)[self.viewControllers firstObject];
}

@end
