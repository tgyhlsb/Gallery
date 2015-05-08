//
//  GAMasterNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAMasterNavigationController.h"

// Controllers
#import "GASettingsInspectorVC.h"

@interface GAMasterNavigationController ()

@property (strong, nonatomic) UIBarButtonItem *settingsButton;

@end

@implementation GAMasterNavigationController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory {
    return [[GAMasterNavigationController alloc] initWithRootDirectory:rootDirectory];
}

- (id)initWithRootDirectory:(GADirectory *)rootDirectory {
    GADirectoryInspectorVC *rootVC = [GADirectoryInspectorVC newWithDirectory:rootDirectory];
    self = [super initWithRootViewController:rootVC];
    if (self) {
        self.navigationBar.translucent = NO;
        [self initializeToolbar];
    }
    return self;
}

#pragma mark - Configuration

- (void)initializeToolbar {
    self.toolbarHidden = NO;
    self.toolbarItems = @[self.settingsButton];
    
//    Buttons are linked to rootViewController
    [[self rootViewController] setToolbarItems:self.toolbarItems];
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

#pragma mark - Broadcast

- (void)notifySelectedDirectory:(GADirectory *)directory {
    [[NSNotificationCenter defaultCenter] postNotificationName:GADirectoryInspectorNotificationSelectedDirectory
                                                        object:self
                                                      userInfo:@{@"directory": directory}];
}

#pragma mark - Handlers

- (void)settingsButtonHandler {
    [self pushViewController:[GASettingsInspectorVC new] animated:YES];
}

#pragma mark - Overrides

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    GADirectoryInspectorVC *previousVC = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
    [self notifySelectedDirectory:previousVC.directory];
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[GADirectoryInspectorVC class]]) {
        [self notifySelectedDirectory:((GADirectoryInspectorVC *)viewController).directory];
        [viewController setToolbarItems:self.toolbarItems];
    } else {
        
    }
    [super pushViewController:viewController animated:animated];
}

@end
