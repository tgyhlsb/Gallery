//
//  GASettingsSplitController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsSplitController.h"

// Controllers
#import "GASettingsInspectorVC.h"
#import "GASettingsDetailVC.h"

@interface GASettingsSplitController ()

@property (strong, nonatomic) UIBarButtonItem *closeButton;

@property (strong, nonatomic) GASettingsInspectorVC *masterVC;
@property (strong, nonatomic) GASettingsDetailVC *detailVC;

@end

@implementation GASettingsSplitController

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        self.masterVC = [GASettingsInspectorVC new];
        self.detailVC = [GASettingsDetailVC new];
        UINavigationController *masterNavController = [[UINavigationController alloc] initWithRootViewController:self.masterVC];
        UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:self.detailVC];
        
        self.viewControllers = @[masterNavController, detailNavController];
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
//        self.delegate = detailRootVC;
    }
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.masterVC.navigationItem.leftBarButtonItem = self.closeButton;
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
