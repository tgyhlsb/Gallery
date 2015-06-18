//
//  SRSettingsSplitViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 18/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSettingsSplitViewController.h"

// Controllers
#import "SRSettingsMasterTableViewController.h"

@interface SRSettingsSplitViewController ()

@property (strong, nonatomic) SRSettingsMasterTableViewController *leftViewController;
@property (strong, nonatomic) UIViewController *detailViewController;

@end

@implementation SRSettingsSplitViewController

#pragma mark - Constructor

- (id)init {
    self = [super init];
    if (self) {
        
        UINavigationController *masterNavigation = [[UINavigationController alloc] initWithRootViewController:self.leftViewController];
        UINavigationController *detailNavigation = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
        self.viewControllers = @[masterNavigation, detailNavigation];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Getters & Setters

- (SRSettingsMasterTableViewController *)leftViewController {
    if (!_leftViewController) {
        _leftViewController = [SRSettingsMasterTableViewController new];
    }
    return _leftViewController;
}

- (UIViewController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [UIViewController new];
    }
    return _detailViewController;
}

@end
