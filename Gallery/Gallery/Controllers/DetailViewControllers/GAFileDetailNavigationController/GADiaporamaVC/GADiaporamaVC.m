//
//  GADiaporamaVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADiaporamaVC.h"

// Controllers
#import "GADirectoryMasterVC.h"
#import "GADiaporamaPagedController.h"

// Managers
#import "GASettingsManager.h"

// Models
#import "GAImageFile.h"
#import "GADirectory.h"

@interface GADiaporamaVC ()

@property (strong, nonatomic) GADiaporamaPagedController *pageViewController;
@property (strong, nonatomic) UIBarButtonItem *showMasterViewButton;
@property (strong, nonatomic) UIBarButtonItem *hideMasterViewButton;

@end

@implementation GADiaporamaVC

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile {
    return [[GADiaporamaVC alloc] initWithRootDirectory:rootDirectory withImageFile:imageFile];
}

- (id)initWithRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile {
    self = [super init];
    if (self) {
        [self setRootDirectory:rootDirectory withImageFile:imageFile];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Force show/hide button to appear
    [self splitViewController:self.navigationController.splitViewController willChangeToDisplayMode:self.navigationController.splitViewController.displayMode];
    
    [self registerToDirectoryInspectorsNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

#pragma mark - Broadcasting

- (void)registerToDirectoryInspectorsNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(directoryInspectorDidSelectDirectory:)
                                                 name:GADirectoryInspectorNotificationSelectedDirectory
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(directoryInspectorDidSelectImageFile:)
                                                 name:GADirectoryInspectorNotificationSelectedImageFile
                                               object:nil];
}

#pragma mark - Getters & Setters

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[GADiaporamaPagedController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        [_pageViewController setParentViewController:self withView:self.view];
        self.navigationItem.rightBarButtonItem = [_pageViewController diaporamaFileTypeBarButton];
    }
    return _pageViewController;
}

- (UIBarButtonItem *)showMasterViewButton {
    if (!_showMasterViewButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_SHOW", nil);
        _showMasterViewButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(showMasterViewButtonHandler)];
    }
    return _showMasterViewButton;
}

- (UIBarButtonItem *)hideMasterViewButton {
    if (!_hideMasterViewButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_HIDE", nil);
        _hideMasterViewButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(hideMasterViewButtonHandler)];
    }
    return _hideMasterViewButton;
}

- (void)setRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile {
    
    if (imageFile) { // show specific file
        [self.pageViewController showImage:imageFile];
    } else { // show directory
        switch ([GASettingsManager directoryNavigationMode]) {
            case GASettingDirectoryNavigationModeIgnore:
                break;
            case GASettingDirectoryNavigationModeShowDirectory:
                [self.pageViewController showDirectory:rootDirectory];
                break;
            case GASettingDirectoryNavigationModeShowFirstImage:
                [self.pageViewController showImage:rootDirectory.firstImage];
                break;
        }
    }
}

#pragma mark - Handlers

- (void)showMasterViewButtonHandler {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideMasterViewButtonHandler {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    } completion:^(BOOL finished) {
    }];
}

- (void)directoryInspectorDidSelectDirectory:(NSNotification *)notification {
    GADirectory *directory = [notification.userInfo objectForKey:@"directory"];
    [self setRootDirectory:directory withImageFile:nil];
}

- (void)directoryInspectorDidSelectImageFile:(NSNotification *)notification {
    GAImageFile *imageFile = [notification.userInfo objectForKey:@"imageFile"];
    [self setRootDirectory:imageFile.parent withImageFile:imageFile];
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        [self.navigationItem setLeftBarButtonItem:self.hideMasterViewButton animated:YES];
    } else if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        [self.navigationItem setLeftBarButtonItem:self.showMasterViewButton animated:YES];
    }
}

@end
