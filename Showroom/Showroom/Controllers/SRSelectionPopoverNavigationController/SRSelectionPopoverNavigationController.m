//
//  SRSelectionPopoverNavigationController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelectionPopoverNavigationController.h"

// Controllers
#import "SRSelectionsTableViewController.h"

// Views
#import "SRAddSelectionBarButton.h"

@interface SRSelectionPopoverNavigationController ()

@end

@implementation SRSelectionPopoverNavigationController

#pragma mark - Constructors

+ (instancetype)new {
    SRSelectionsTableViewController *rootViewController = [SRSelectionsTableViewController new];
    
    SRSelectionPopoverNavigationController *navigationController = [[SRSelectionPopoverNavigationController alloc] initWithRootViewController:rootViewController];
    
    rootViewController.title = NSLocalizedString(@"LOCALIZE_SELECTION_LIST_TITLE", nil);
    rootViewController.navigationItem.rightBarButtonItem = [[SRAddSelectionBarButton alloc] initWithTarget:navigationController
                                                                                                    action:@selector(addSelectionButtonHandler)];
    
    return navigationController;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Handlers

- (void)addSelectionButtonHandler {
    
}

@end
