//
//  GARightNavigationVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GARightNavigationVC.h"

// Controllers
#import "GARightVC.h"

@interface GARightNavigationVC ()

@end

@implementation GARightNavigationVC

#pragma mark - Constructors

+ (instancetype)new {
    GARightVC *rootVC = [GARightVC new];
    GARightNavigationVC *navVC = [[GARightNavigationVC alloc] initWithRootViewController:rootVC];
    return navVC;
}

#pragma mark - GADirectoryInspectorDelegate

- (void)directoryInspector:(GADirectoryInspectorVC *)inspectorVC didSelectImageFile:(GAImageFile *)imageFile {
    GARightVC *rootVC = [GARightVC new];
    rootVC.imageFile = imageFile;
    [self setViewControllers:@[rootVC] animated:YES];
}

@end
