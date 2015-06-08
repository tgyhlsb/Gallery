//
//  SRImageNavigationController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImageNavigationController.h"

// Managers
#import "SRImagesCollectionViewController.h"
#import "SRLogger.h"

@interface SRImageNavigationController ()

@end

@implementation SRImageNavigationController

#pragma mark - Constructors

+ (instancetype)newWithDirectory:(SRDirectory *)directory {
    return [[SRImageNavigationController alloc] initWithDirectory:directory];
}

- (id)initWithDirectory:(SRDirectory *)directory {
    SRImagesCollectionViewController *rootController = [SRImagesCollectionViewController newWithDirectory:directory];
    self = [super initWithRootViewController:rootController];
    if (self) {
        self.toolbarHidden = NO;
    }
    return self;
}

#pragma mark - View life cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.toolbar.translucent = NO;
}

@end
