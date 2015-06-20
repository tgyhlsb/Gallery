//
//  SRSettingsSplitViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 18/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSettingsSplitViewController.h"

// Controllers
#import "MEDeclarativeTable.h"

@interface SRSettingsSplitViewController ()

@property (strong, nonatomic) UITableViewController *masterTableViewController;
@property (strong, nonatomic) UITableViewController *detailTableViewController;

@property (strong, nonatomic) MEDeclarativeTable *masterTable;

@end

@implementation SRSettingsSplitViewController

#pragma mark - Configuration

#pragma mark Master Table

- (void)configureMasterTable {
    [self.masterTable addSection:[self exampleSection]];
}

- (MEDeclarativeTableSection *)exampleSection {
    MEDeclarativeTableSection *section = [[MEDeclarativeTableSection alloc] init];
    section.headerTitle = @"Test";
    
    MEDeclarativeTableRow *row = [[MEDeclarativeTableRow alloc] init];
    row.textLabelText = @"Cell";
    
    [section addRow:row];
    return section;
}

#pragma mark - Constructor

- (id)init {
    self = [super init];
    if (self) {
        
        UINavigationController *masterNavigation = [[UINavigationController alloc] initWithRootViewController:self.masterTableViewController];
        UINavigationController *detailNavigation = [[UINavigationController alloc] initWithRootViewController:self.detailTableViewController];
        
        masterNavigation.navigationBar.translucent = NO;
        masterNavigation.navigationBar.barTintColor = [UIColor colorWithRed:0.12f green:0.45f blue:0.66f alpha:1.00f];
        detailNavigation.navigationBar.translucent = NO;
        detailNavigation.navigationBar.barTintColor = [UIColor colorWithRed:0.12f green:0.45f blue:0.66f alpha:1.00f];
        
        self.viewControllers = @[masterNavigation, detailNavigation];
        
        
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
    return self;
}

#pragma mark - View life cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Getters & Setters

- (UITableViewController *)masterTableViewController {
    if (!_masterTableViewController) {
        _masterTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _masterTableViewController.tableView.delegate = self.masterTable;
        _masterTableViewController.tableView.dataSource = self.masterTable;
    }
    return _masterTableViewController;
}

- (UITableViewController *)detailTableViewController {
    if (!_detailTableViewController) {
        _detailTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _detailTableViewController;
}

- (void)setCloseButton:(UIBarButtonItem *)closeButton {
    _closeButton = closeButton;
    self.masterTableViewController.navigationItem.leftBarButtonItem = closeButton;
}

#pragma mark - Declarative tables

- (MEDeclarativeTable *)masterTable {
    if (!_masterTable) {
        _masterTable = [[MEDeclarativeTable alloc] init];
        [self configureMasterTable];
    }
    return _masterTable;
}

@end
