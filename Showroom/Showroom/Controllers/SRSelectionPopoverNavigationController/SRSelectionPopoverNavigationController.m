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
#import "SRCreateSelectionViewController.h"

// Views
#import "SRAddSelectionBarButton.h"

// Model
#import "SRModel.h"

@interface SRSelectionPopoverNavigationController () <SRSelectionsTableViewControllerDelegate>

@end

@implementation SRSelectionPopoverNavigationController

#pragma mark - Constructors

+ (instancetype)new {
    SRSelectionsTableViewController *rootViewController = [SRSelectionsTableViewController new];
    
    SRSelectionPopoverNavigationController *navigationController = [[SRSelectionPopoverNavigationController alloc] initWithRootViewController:rootViewController];
    
    rootViewController.title = NSLocalizedString(@"LOCALIZE_SELECTION_LIST_TITLE", nil);
    rootViewController.delegate = navigationController;
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
    SRCreateSelectionViewController *destination = [SRCreateSelectionViewController new];
    [self pushViewController:destination animated:YES];
}

#pragma mark - SRSelectionsTableViewControllerDelegate

- (void)selectionsTableViewController:(SRSelectionsTableViewController *)controller didSelectSelection:(SRSelection *)selection {
    SRModel *model = [SRModel defaultModel];
    if ([selection isEqual:model.activeSelection]) {
        [model setActiveSelection:nil];
    } else {
        [model setActiveSelection:selection];
        
        if (self.closeBlock) {
            self.closeBlock();
            self.closeBlock = nil;
        }
    }
}

@end
