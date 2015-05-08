//
//  GADirectoryNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryNavigationController.h"

@interface GADirectoryNavigationController ()

@property (strong, nonatomic) GADirectory *rootDirectory;

@end

@implementation GADirectoryNavigationController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory {
    return [[GADirectoryNavigationController alloc] initWithRootDirectory:rootDirectory];
}

- (id)initWithRootDirectory:(GADirectory *)rootDirectory {
    GADirectoryInspectorVC *rootVC = [GADirectoryInspectorVC newWithDirectory:rootDirectory];
    self = [super initWithRootViewController:rootVC];
    if (self) {
        self.rootDirectory = rootDirectory;
        self.navigationBar.translucent = NO;
    }
    return self;
}

#pragma mark - Getters & Setters

- (GADirectoryInspectorVC *)rootViewController {
    return (GADirectoryInspectorVC *)[self.viewControllers firstObject];
}

@end
