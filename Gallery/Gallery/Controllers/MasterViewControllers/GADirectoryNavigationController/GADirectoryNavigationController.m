//
//  GADirectoryNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryNavigationController.h"

// Controllers
#import "GASettingsSplitController.h"

@interface GADirectoryNavigationController ()

@property (strong, nonatomic) UIBarButtonItem *settingsButton;

@end

@implementation GADirectoryNavigationController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory {
    return [[GADirectoryNavigationController alloc] initWithRootDirectory:rootDirectory];
}

- (id)initWithRootDirectory:(GADirectory *)rootDirectory {
    GADirectoryMasterVC *rootVC = [GADirectoryMasterVC newWithDirectory:rootDirectory];
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

- (GADirectoryMasterVC *)rootViewController {
    return (GADirectoryMasterVC *)[self.viewControllers firstObject];
}

- (UIBarButtonItem *)settingsButton {
    if (!_settingsButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_SETTINGS", nil);
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
    [self presentViewController:[GASettingsSplitController new] animated:YES completion:^{
        
    }];
}

#pragma mark - Overrides

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    GADirectoryMasterVC *previousVC = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
    [self notifySelectedDirectory:previousVC.directory];
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[GADirectoryMasterVC class]]) {
        [self notifySelectedDirectory:((GADirectoryMasterVC *)viewController).directory];
        [viewController setToolbarItems:self.toolbarItems];
    } else {
        
    }
    [super pushViewController:viewController animated:animated];
}

@end
