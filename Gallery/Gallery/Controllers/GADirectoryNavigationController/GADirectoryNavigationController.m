//
//  GADirectoryNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryNavigationController.h"

@interface GADirectoryNavigationController ()

@property (strong, nonatomic) UIBarButtonItem *settingsButton;

@property (strong, nonatomic) GADirectory *rootDirectory;

@end

@implementation GADirectoryNavigationController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory {
    return [[GADirectoryNavigationController alloc] initWithRootDirectory:rootDirectory];
}

- (id)initWithRootDirectory:(GADirectory *)rootDirectory {
    GADirectoryInspectorVC *rootVC = [GADirectoryInspectorVC newWithDirectory:rootDirectory];
    self = [super initWithRootViewController:rootVC];
    if (self) {
        self.rootDirectory = rootDirectory;
        self.navigationBar.translucent = NO;
        
        [self initializeToolbar];
    }
    return self;
}

#pragma mark - Configuration

- (void)initializeToolbar {
    self.toolbarHidden = NO;
    
//    Buttons are linked to rootViewController
    [[self.viewControllers firstObject] setToolbarItems:@[self.settingsButton]];
}

#pragma mark - Getters & Setters

- (GADirectoryInspectorVC *)rootViewController {
    return (GADirectoryInspectorVC *)[self.viewControllers firstObject];
}

- (UIBarButtonItem *)settingsButton {
    if (!_settingsButton) {
        NSString *title = NSLocalizedString(@"SETTINGS", nil);
        _settingsButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(settingsButtonHandler)];
    }
    return _settingsButton;
}

#pragma mark - Handlers

- (void)settingsButtonHandler {
    [self pushViewController:[UIViewController new] animated:YES];
}

@end
