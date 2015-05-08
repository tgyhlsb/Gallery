//
//  GADiaporamaVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADiaporamaVC.h"

#import "GARightVC.h"

// Managers
#import "GASettingsManager.h"

// Models
#import "GAFile+Pointers.h"
#import "GAImageFile.h"
#import "GADirectory.h"

// Others
#import "NSMutableArray+GAStack.h"

#define PAGED_CONTROLLERS_CLASS GARightVC

@interface GADiaporamaVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIBarButtonItem *showMasterViewButton;
@property (strong, nonatomic) UIBarButtonItem *hideMasterViewButton;
@property (strong, nonatomic) NSMutableArray *viewControllersStack;

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
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.frame = self.view.bounds;
        [self.view addSubview:_pageViewController.view];
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

- (NSMutableArray *)viewControllersStack {
    if (!_viewControllersStack) _viewControllersStack = [[NSMutableArray alloc] initWithObjects:[GARightVC new], [GARightVC new], [GARightVC new], [GARightVC new], [GARightVC new], nil];
    return _viewControllersStack;
}

- (void)setRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile {
    PAGED_CONTROLLERS_CLASS *vc = [PAGED_CONTROLLERS_CLASS new];
    
    if (imageFile) { // show specific file
        vc.file = imageFile;
    } else { // show directory
        switch ([GASettingsManager directoryNavigationMode]) {
            case GASettingDirectoryNavigationModeIgnore:
                break;
            case GASettingDirectoryNavigationModeShowDirectory:
                vc.file = rootDirectory;
                break;
            case GASettingDirectoryNavigationModeShowFirstImage:
                vc.file = rootDirectory.firstImage;
                break;
        }
    }
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    PAGED_CONTROLLERS_CLASS *beforeVC = [PAGED_CONTROLLERS_CLASS new];
    PAGED_CONTROLLERS_CLASS *activeVC = ((PAGED_CONTROLLERS_CLASS *)viewController);
    beforeVC.file = [self previousFile:activeVC.file];
    return beforeVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PAGED_CONTROLLERS_CLASS *afterVC = [PAGED_CONTROLLERS_CLASS new];
    PAGED_CONTROLLERS_CLASS *activeVC = ((PAGED_CONTROLLERS_CLASS *)viewController);
    afterVC.file = [self nextFile:activeVC.file];
    return afterVC;
}

- (GAFile *)previousFile:(GAFile *)file {
    return [file previous];
}

- (GAFile *)nextFile:(GAFile *)file {
    return [file next];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
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
