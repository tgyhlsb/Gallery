//
//  GASettingsDetailNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsDetailNavigationController.h"

// Controllers
#import "GASettingsDetailVC.h"
#import "GASettingsDetailThumbnailsVC.h"
#import "GASettingsDetailDirectoryNavigation.h"

@interface GASettingsDetailNavigationController ()

@end

@implementation GASettingsDetailNavigationController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GASettingsInspectorDelegate

- (void)settingsInspectorDidSelectThumbnailsSettings {
    GASettingsDetailThumbnailsVC *destination = [GASettingsDetailThumbnailsVC new];
    destination.title = NSLocalizedString(@"SETTINGS_THUMBNAILS_TITLE", nil);
    [self setViewControllers:@[destination]];
}

- (void)settingsInspectorDidSelectDirectoryNavigationSettings {
    GASettingsDetailDirectoryNavigation *destination = [GASettingsDetailDirectoryNavigation new];
    destination.title = NSLocalizedString(@"SETTINGS_DIRECTORY_NAVIGATION_TITLE", nil);
    [self setViewControllers:@[destination]];
    
}

- (void)settingsInspectorDidSelectLoggerSettings {
    GASettingsDetailVC *destination = [GASettingsDetailVC new];
    destination.title = NSLocalizedString(@"SETTINGS_LOGGER_TITLE", nil);
    [self setViewControllers:@[destination]];
    
}

@end
