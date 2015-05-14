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

@interface GADirectoryNavigationController () <GADirectoryViewControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *settingsButton;

@end

@implementation GADirectoryNavigationController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)directory {
    return [[GADirectoryNavigationController alloc] initWithRootDirectory:directory];
}

- (id)initWithRootDirectory:(GADirectory *)directory {
    GADirectoryMasterVC *rootVC = [GADirectoryMasterVC newWithDirectory:directory];
    self = [super initWithRootViewController:rootVC];
    if (self) {
        self.navigationBar.translucent = NO;
        rootVC.delegate = self;
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

#pragma mark - Handlers

- (void)settingsButtonHandler {
    [self presentViewController:[GASettingsSplitController new] animated:YES completion:^{
        
    }];
}

#pragma mark - Overrides

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    GADirectoryMasterVC *previousVC = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
    previousVC.delegate = self;
    [self notifyDidSelectDirectory:previousVC.directory];
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController setToolbarItems:self.toolbarItems];
    [super pushViewController:viewController animated:animated];
}

#pragma mark - GADirectoryViewControllerDelegate

- (void)directoryViewController:(GADirectoryMasterVC *)controller didSelectFile:(GAFile *)file {
    if (file.isImage) {
        [self openImagefile:(GAImageFile *)file];
    } else if (file.isDirectory) {
        [self openDirectory:(GADirectory *)file];
    } else {
        
    }
}

- (void)openDirectory:(GADirectory *)directory {
    [self pushControllerForDirectory:directory];
    [self notifyDidSelectDirectory:directory];
}

- (void)pushControllerForDirectory:(GADirectory *)directory {
    GADirectoryMasterVC *destination = [GADirectoryMasterVC newWithDirectory:directory];
    destination.title = [directory nameWithExtension:YES];
    destination.delegate = self;
    [self pushViewController:destination animated:YES];
}

- (void)openImagefile:(GAImageFile *)imageFile {
    [self notifyDidSelectImageFile:imageFile];
}

#pragma mark - Broadcast

- (void)notifyDidSelectDirectory:(GADirectory *)directory {
    
}

- (void)notifyDidSelectImageFile:(GAImageFile *)imageFile {
    
}

@end
