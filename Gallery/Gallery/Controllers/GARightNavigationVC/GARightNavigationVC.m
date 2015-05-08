//
//  GARightNavigationVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GARightNavigationVC.h"

// Controllers
#import "GADiaporamaVC.h"

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

#pragma mark - GADirectoryInspectorDelegate

- (void)directoryInspector:(GADirectoryInspectorVC *)inspectorVC didSelectImageFile:(GAImageFile *)imageFile {
    GADiaporamaVC *rootVC = [self.viewControllers firstObject];
    [rootVC setRootDirectory:nil withImageFile:imageFile];
}

- (void)directoryInspector:(GADirectoryInspectorVC *)inspectorVC didSelectDirectory:(GADirectory *)directory {
    GADiaporamaVC *rootVC = [self.viewControllers firstObject];
    [rootVC setRootDirectory:directory withImageFile:nil];
}

@end
