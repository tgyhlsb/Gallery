//
//  GASettingsSplitController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsSplitController.h"

// Controllers
#import "GASettingsMasterVC.h"
#import "GASettingsDetailNavigationController.h"
#import "GASettingsDetailVC.h"

@interface GASettingsSplitController ()

@property (strong, nonatomic) UIBarButtonItem *closeButton;

@property (strong, nonatomic) GASettingsMasterVC *masterVC;
@property (strong, nonatomic) GASettingsDetailVC *detailVC;
@property (strong, nonatomic) GASettingsDetailNavigationController *detailNavigationController;

@end

@implementation GASettingsSplitController

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        self.masterVC = [GASettingsMasterVC new];
        self.detailVC = [GASettingsDetailVC new];
        UINavigationController *masterNavController = [[UINavigationController alloc] initWithRootViewController:self.masterVC];
        self.detailNavigationController = [[GASettingsDetailNavigationController alloc] initWithRootViewController:self.detailVC];
        
        self.viewControllers = @[masterNavController, self.detailNavigationController];
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.delegate = self.detailNavigationController;
    }
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.masterVC.navigationItem.leftBarButtonItem = self.closeButton;
    
    self.masterVC.delegate = self.detailNavigationController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

- (UIBarButtonItem *)closeButton {
    if (!_closeButton) {
        NSString *title = NSLocalizedString(@"CLOSE", nil);
        _closeButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(closeButtonHandler)];
    }
    return _closeButton;
}

#pragma mark - Handler 

- (void)closeButtonHandler {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
