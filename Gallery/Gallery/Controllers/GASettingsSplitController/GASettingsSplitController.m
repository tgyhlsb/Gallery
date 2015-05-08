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

@interface GASettingsSplitController ()

@end

@implementation GASettingsSplitController

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        GASettingsInspectorVC *masterRootVC = [GASettingsInspectorVC new];
        UIViewController *detailRootVC = [UIViewController new];
        UINavigationController *masterNavController = [[UINavigationController alloc] initWithRootViewController:masterRootVC];
        UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:detailRootVC];
        
        self.viewControllers = @[masterNavController, detailNavController];
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
//        self.delegate = detailRootVC;
    }
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

@end
