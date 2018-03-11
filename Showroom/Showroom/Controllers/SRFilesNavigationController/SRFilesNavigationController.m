//
//  SRFilesNavigationController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRFilesNavigationController.h"

// Managers
#import "SRFilesTableViewController.h"
#import "SRLogger.h"

@interface SRFilesNavigationController()


@end

@implementation SRFilesNavigationController

#pragma mark - Constructors

+ (instancetype)newWithDirectory:(SRDirectory *)directory {
    return [[SRFilesNavigationController alloc] initWithDirectory:directory];
}

- (id)initWithDirectory:(SRDirectory *)directory {
    SRFilesTableViewController *rootController = [SRFilesTableViewController newWithDirectory:directory];
    self = [super initWithRootViewController:rootController];
    if (self) {
        
    }
    return self;
}

@end
