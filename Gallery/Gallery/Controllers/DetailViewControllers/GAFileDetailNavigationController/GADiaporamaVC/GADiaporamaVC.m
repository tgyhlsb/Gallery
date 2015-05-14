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

@interface GADiaporamaVC () <GADiaporamaPagedControllerDelegate>

@property (strong, nonatomic) GADiaporamaPagedController *diaporamaController;
@property (strong, nonatomic) UIBarButtonItem *showMasterViewButton;
@property (strong, nonatomic) UIBarButtonItem *hideMasterViewButton;

@property (strong, nonatomic) NSArray *topLeftBarItems;
@property (strong, nonatomic) NSArray *topRightBarItems;
@property (strong, nonatomic) NSArray *bottomLeftBarItems;
@property (strong, nonatomic) NSArray *bottomRightBarItems;

@end

@implementation GADiaporamaVC

#pragma mark - Constructors

+ (instancetype)newWithFileNavigator:(GAFileNavigator *)fileNavigator {
    return [[GADiaporamaVC alloc] initWithFileNavigator:fileNavigator];
}

- (id)initWithFileNavigator:(GAFileNavigator *)fileNavigator {
    self = [super init];
    if (self) {
        self.fileNavigator = fileNavigator;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showSplitButton) {
        // Force show/hide button to appear
        self.topLeftBarItems = @[self.hideMasterViewButton];
    }
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

#pragma mark - Getters & Setters

- (GADiaporamaPagedController *)diaporamaController {
    if (!_diaporamaController) {
        _diaporamaController = [GADiaporamaPagedController new];
        [_diaporamaController setParentViewController:self withView:self.view];
        _diaporamaController.delegate = self;
        _diaporamaController.fileNavigator = self.fileNavigator;
    }
    return _diaporamaController;
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

#pragma mark Bar items

- (void)setTopLeftBarItems:(NSArray *)topLeftBarItems {
    _topLeftBarItems = topLeftBarItems;
    [self updateNavigationBarLeftItems];
}

- (void)setTopRightBarItems:(NSArray *)topRightBarItems {
    _topRightBarItems = topRightBarItems;
    [self updateNavigationBarRightItems];
}

- (void)setBottomLeftBarItems:(NSArray *)bottomLeftBarItems {
    _bottomLeftBarItems = bottomLeftBarItems;
    [self updateToolBarItems];
}

- (void)setBottomRightBarItems:(NSArray *)bottomRightBarItems {
    _bottomRightBarItems = bottomRightBarItems;
    [self updateToolBarItems];
}

#pragma mark - Handlers

- (void)showMasterViewButtonHandler {
    self.topLeftBarItems = nil;
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideMasterViewButtonHandler {
    self.topLeftBarItems = nil;
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        self.topLeftBarItems = @[self.hideMasterViewButton];
    } else if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.topLeftBarItems = @[self.showMasterViewButton];
    }
}

#pragma mark - GADiaporamaPagedControllerDelegate

- (void)diaporamaPagedControllerDidUpdateBarItems:(GADiaporamaPagedController *)diaporamaPagedController {
    [self updateNavigationBarLeftItems];
    [self updateNavigationBarRightItems];
    [self updateToolBarItems];
}

#define ANIMATED NO

- (void)updateNavigationBarLeftItems {
    if ([self.diaporamaController respondsToSelector:@selector(topLeftBarItems)]) {
        NSArray *childItems = [self.diaporamaController topLeftBarItemsForDisplayedFile];
        NSArray *items = [self arrayWithArray:self.topLeftBarItems andArray:childItems];
        [self.navigationItem setLeftBarButtonItems:items animated:ANIMATED];
    } else {
        [self.navigationItem setLeftBarButtonItems:self.topLeftBarItems animated:ANIMATED];
    }
}

- (void)updateNavigationBarRightItems {
    if ([self.diaporamaController respondsToSelector:@selector(topRightBarItems)]) {
        NSArray *childItems = [self.diaporamaController topRightBarItemsForDisplayedFile];
        NSArray *items = [self arrayWithArray:self.topRightBarItems andArray:childItems];
        [self.navigationItem setRightBarButtonItems:items animated:ANIMATED];
    } else {
        [self.navigationItem setRightBarButtonItems:self.topRightBarItems animated:ANIMATED];
    }
}

- (void)updateToolBarItems {
    NSArray *childLeftItems = nil;
    NSArray *childRightItems = nil;
    if ([self.diaporamaController respondsToSelector:@selector(bottomLeftBarItemsForDisplayedFile)]) {
        childLeftItems = [self.diaporamaController bottomLeftBarItemsForDisplayedFile];
    }
    if ([self.diaporamaController respondsToSelector:@selector(bottomRightBarItemsForDisplayedFile)]) {
        childRightItems = [self.diaporamaController bottomRightBarItemsForDisplayedFile];
    }
    
    NSArray *leftItems = [self arrayWithArray:self.bottomLeftBarItems andArray:childLeftItems];
    NSArray *rightItems = [self arrayWithArray:self.bottomRightBarItems andArray:childRightItems];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    [toolBarItems addObjectsFromArray:leftItems];
    [toolBarItems addObject:flexibleItem];
    [toolBarItems addObjectsFromArray:rightItems];
    
    self.toolbarItems = toolBarItems;
}

#pragma mark - Helpers

- (NSArray *)arrayWithArray:(NSArray *)array1 andArray:(NSArray *)array2 {
    NSMutableArray *result = [NSMutableArray arrayWithArray:array1];
    [result addObjectsFromArray:array2];
    return result;
}

@end
