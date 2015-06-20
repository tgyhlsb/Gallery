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

+ (instancetype)newWithResultController:(NSFetchedResultsController *)fetchResultController {
    return [[SRImageNavigationController alloc] initWithResultController:fetchResultController];
}

- (id)initWithResultController:(NSFetchedResultsController *)fetchResultController {
    SRImagesCollectionViewController *rootController = [SRImagesCollectionViewController newWithResultController:fetchResultController];
    self = [super initWithRootViewController:rootController];
    if (self) {
        self.toolbarHidden = YES;
    }
    return self;
}

#pragma mark - View life cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toolbar.translucent = NO;
}

@end
