//
//  GADiaporamaPagedController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADiaporamaPagedController.h"

// Managers
#import "GALogger.h"

// Controllers
#import "GAFileInspectorVC.h"

// Models
#import "GAFile+Pointers.h"

#define PAGED_CONTROLLERS_CLASS GAFileInspectorVC

@interface GADiaporamaPagedController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) PAGED_CONTROLLERS_CLASS *centerViewController;

@property (strong, nonatomic) UISegmentedControl *diaporamaFileTypeSegmentedControl;

@property (strong, nonatomic) NSArray *topLeftBarItems;
@property (strong, nonatomic) NSArray *topRightBarItems;
@property (strong, nonatomic) NSArray *bottomLeftBarItems;
@property (strong, nonatomic) NSArray *bottomRightBarItems;

@end

@implementation GADiaporamaPagedController

#pragma mark - Constructors

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setParentViewController:(UIViewController *)parent withView:(UIView *)view {
    self.view.frame = view.bounds;
    [parent addChildViewController:self];
    [view addSubview:self.view];
    [self didMoveToParentViewController:parent];
}

#pragma mark - Getters & Setters

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        [self addChildViewController:_pageViewController];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        _pageViewController.view.frame = self.view.bounds;
        [self.view addSubview:_pageViewController.view];
        [_pageViewController didMoveToParentViewController:self];
    }
    return _pageViewController;
}

- (void)setDiaporamaFileType:(GADiaporamaFileType)diaporamaFileType {
    _diaporamaFileType = diaporamaFileType;
}

- (UISegmentedControl *)diaporamaFileTypeSegmentedControl {
    if (!_diaporamaFileTypeSegmentedControl) {
        _diaporamaFileTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[
                                                                                NSLocalizedString(@"LOCALIZE_ALL", nil),
                                                                                NSLocalizedString(@"LOCALIZE_IMAGES", nil),
                                                                                NSLocalizedString(@"LOCALIZE_DIRECTORIES", nil)
                                                                                ]];
        _diaporamaFileTypeSegmentedControl.selectedSegmentIndex = self.diaporamaFileType;
        [_diaporamaFileTypeSegmentedControl addTarget:self action:@selector(diaporamaFileTypeValueDidChangeHandler) forControlEvents:UIControlEventValueChanged];
    }
    return _diaporamaFileTypeSegmentedControl;
}

- (UIBarButtonItem *)diaporamaFileTypeBarButton {
    return [[UIBarButtonItem alloc] initWithCustomView:self.diaporamaFileTypeSegmentedControl];
}

- (void)setBarItemDataSource:(id<GAFileInspectorBarButtonsDataSource>)barItemDataSource {
    _barItemDataSource = barItemDataSource;
    [self notifyDidChangeBarItems];
}

#pragma mark - BarItems

- (NSArray *)topRightBarItems {
    if (!_topRightBarItems) {
        _topRightBarItems = @[self.diaporamaFileTypeBarButton];
    }
    return _topRightBarItems;
}

#pragma mark - Handlers

- (void)diaporamaFileTypeValueDidChangeHandler {
    [self reloadCenterViewController]; // needed if left and right VC are already dequeued
    self.diaporamaFileType = self.diaporamaFileTypeSegmentedControl.selectedSegmentIndex;
    
    switch (self.diaporamaFileTypeSegmentedControl.selectedSegmentIndex) {
        case GADiaporamaFileTypeAll:
            break;
        case GADiaporamaFileTypeImages:
            if (![self.centerViewController.file isImage]) [self showNext];
            break;
        case GADiaporamaFileTypeDirectories:
            if (![self.centerViewController.file isDirectory]) [self showNext];
            break;
    }
}

#pragma mark - Navigation

- (PAGED_CONTROLLERS_CLASS *)dequeueControllerForFile:(GAFile *)file {
    [self notifyMayShowFile:file];
    return [PAGED_CONTROLLERS_CLASS inspectorForFile:file];
}

- (void)setCenterViewController:(GAFileInspectorVC *)controller {
    [self setCenterViewController:controller animated:NO];
}

- (void)setCenterViewController:(GAFileInspectorVC *)controller animated:(BOOL)animated {
    [self notifyWillShowFile:controller.file];
    __weak GADiaporamaPagedController *weakSelf = self;
    [self.pageViewController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:^(BOOL finished) {
        if (finished) {
            [weakSelf centerViewControllerWasReplaced:controller];
        }
    }];
}

- (void)showFile:(GAFile *)file {
    if (file.isDirectory) {
        [self showDirectory:(GADirectory *)file];
    } else if (file.isImage) {
        [self showImage:(GAImageFile *)file];
    } else {
        [GALogger addError:@"Tried to show invalid file \"%@\" in %@", file, self];
    }
}

- (void)showImage:(GAImageFile *)imageFile {
    PAGED_CONTROLLERS_CLASS *controller = [self dequeueControllerForFile:imageFile];
    [self setCenterViewController:controller animated:NO];
    if (self.diaporamaFileType == GADiaporamaFileTypeDirectories) self.diaporamaFileType = GADiaporamaFileTypeAll;
}

- (void)showDirectory:(GADirectory *)directory {
    PAGED_CONTROLLERS_CLASS *controller = [self dequeueControllerForFile:directory];
    [self setCenterViewController:controller animated:NO];
    if (self.diaporamaFileType == GADiaporamaFileTypeImages) self.diaporamaFileType = GADiaporamaFileTypeAll;
}

- (void)reloadCenterViewController {
    [self setCenterViewController:self.centerViewController animated:NO];
}

- (void)showNext {
    GAFile *nextFile = [self nextFile:self.centerViewController.file];
    if (nextFile) {
        PAGED_CONTROLLERS_CLASS *controller = [self dequeueControllerForFile:nextFile];
        [self setCenterViewController:controller animated:YES];
    } else {
        self.diaporamaFileType = GADiaporamaFileTypeAll;
    }
}

- (void)showPrevious {
    GAFile *previousFile = [self previousFile:self.centerViewController.file];
    if (previousFile) {
        PAGED_CONTROLLERS_CLASS *controller = [self dequeueControllerForFile:previousFile];
        [self setCenterViewController:controller animated:YES];
    } else {
        self.diaporamaFileType = GADiaporamaFileTypeAll;
    }
}

#pragma mark - File data source


- (GAFile *)previousFile:(GAFile *)file {
    GAFile *previous = nil;
    switch (self.diaporamaFileType) {
        case GADiaporamaFileTypeAll:
            previous = [file previous]; break;
        case GADiaporamaFileTypeImages:
            previous = [file previousImage]; break;
        case GADiaporamaFileTypeDirectories:
            previous = [file previousDirectory]; break;
    }
    return [previous isEqual:file] ? nil : previous;
}

- (GAFile *)nextFile:(GAFile *)file {
    GAFile *next = nil;
    switch (self.diaporamaFileType) {
        case GADiaporamaFileTypeAll:
            next = [file next]; break;
        case GADiaporamaFileTypeImages:
            next = [file nextImage]; break;
        case GADiaporamaFileTypeDirectories:
            next = [file nextDirectory]; break;
    }
    return [next isEqual:file] ? nil : next;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    PAGED_CONTROLLERS_CLASS *activeVC = ((PAGED_CONTROLLERS_CLASS *)viewController);
    GAFile *file = [self previousFile:activeVC.file];
    if (!file) return nil;
    PAGED_CONTROLLERS_CLASS *beforeVC = [self dequeueControllerForFile:file];
    return beforeVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PAGED_CONTROLLERS_CLASS *activeVC = ((PAGED_CONTROLLERS_CLASS *)viewController);
    GAFile *file = [self nextFile:activeVC.file];
    if (!file) return nil;
    PAGED_CONTROLLERS_CLASS *afterVC = [self dequeueControllerForFile:file];
    return afterVC;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if (finished && completed) {
        [self centerViewControllerWasReplaced:[pageViewController.viewControllers firstObject]];
    }
}

- (void)centerViewControllerWasReplaced:(GAFileInspectorVC *)centerViewController {
    self.barItemDataSource = centerViewController;
    _centerViewController = centerViewController;
    [self notifyDidShowFile:centerViewController.file];
}

#pragma mark - GADiaporamaPagedControllerDelegate

- (void)notifyDidChangeBarItems {
    if ([self.delegate respondsToSelector:@selector(diaporamaPagedControllerDidUpdateBarItems:)]) {
        [self.delegate diaporamaPagedControllerDidUpdateBarItems:self];
    }
}

- (void)notifyMayShowFile:(GAFile *)file {
    if ([self.delegate respondsToSelector:@selector(diaporamaPagedController:mayShowFile:)]) {
        [self.delegate diaporamaPagedController:self mayShowFile:file];
    }
}

- (void)notifyWillShowFile:(GAFile *)file {
    if ([self.delegate respondsToSelector:@selector(diaporamaPagedController:willShowFile:)]) {
        [self.delegate diaporamaPagedController:self willShowFile:file];
    }
}

- (void)notifyDidShowFile:(GAFile *)file {
    if ([self.delegate respondsToSelector:@selector(diaporamaPagedController:didShowFile:)]) {
        [self.delegate diaporamaPagedController:self didShowFile:file];
    }
}

#pragma mark - Bar items

- (NSArray *)topLeftBarItemsForDisplayedFile {
    if ([self.barItemDataSource respondsToSelector:@selector(topLeftBarItemsForDisplayedFile)]) {
        return [self arrayWithArray:self.topLeftBarItems andArray:[self.barItemDataSource topLeftBarItemsForDisplayedFile]];
    }
    return self.topLeftBarItems;
}

- (NSArray *)topRightBarItemsForDisplayedFile {
    if ([self.barItemDataSource respondsToSelector:@selector(topRightBarItemsForDisplayedFile)]) {
        return [self arrayWithArray:self.topRightBarItems andArray:[self.barItemDataSource topRightBarItemsForDisplayedFile]];
    }
    return self.topRightBarItems;
}

- (NSArray *)bottomLeftBarItemsForDisplayedFile {
    if ([self.barItemDataSource respondsToSelector:@selector(bottomLeftBarItemsForDisplayedFile)]) {
        return [self arrayWithArray:self.bottomLeftBarItems andArray:[self.barItemDataSource bottomLeftBarItemsForDisplayedFile]];
    }
    return self.bottomLeftBarItems;
}

- (NSArray *)bottomRightBarItemsForDisplayedFile {
    if ([self.barItemDataSource respondsToSelector:@selector(bottomRightBarItemsForDisplayedFile)]) {
        return [self arrayWithArray:self.bottomRightBarItems andArray:[self.barItemDataSource bottomRightBarItemsForDisplayedFile]];
    }
    return self.bottomRightBarItems;
}

#pragma mark - Helpers

- (NSArray *)arrayWithArray:(NSArray *)array1 andArray:(NSArray *)array2 {
    NSMutableArray *result = [NSMutableArray arrayWithArray:array1];
    [result addObjectsFromArray:array2];
    return result;
}

@end