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

@property (strong, nonatomic) PAGED_CONTROLLERS_CLASS *centerViewController;

@property (strong, nonatomic) UISegmentedControl *diaporamaFileTypeSegmentedControl;

@end

@implementation GADiaporamaPagedController

#pragma mark - Constructors

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style
        navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation
                      options:(NSDictionary *)options {
    
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

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

#pragma mark - Handlers

- (void)diaporamaFileTypeValueDidChangeHandler {
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
    return [PAGED_CONTROLLERS_CLASS inspectorForFile:file];
}

- (void)setCenterViewController:(GAFileInspectorVC *)controller {
    [self setCenterViewController:controller animated:NO];
}

- (void)setCenterViewController:(GAFileInspectorVC *)controller animated:(BOOL)animated {
    _centerViewController = controller;
    [self setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:^(BOOL finished) {
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
    PAGED_CONTROLLERS_CLASS *afterVC = [self dequeueControllerForFile:file];;
    return afterVC;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if (finished && completed) {
        _centerViewController = [pageViewController.viewControllers firstObject];
    }
}

@end
