//
//  GADirectoryNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryNavigationController.h"

// Controllers
#import "GADirectoryInspectorVC.h"

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
    }
    return self;
}

@end