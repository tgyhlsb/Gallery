//
//  SRDiaporamaViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 04/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRDiaporamaViewController.h"

// Controllers
#import "SRImageViewController.h"
#import "SRSelectionPopoverNavigationController.h"

// Model
#import "SRModel.h"

// Views
#import "SRSelectionPickerBarButton.h"
#import "SRAddAndRemoveSelectionBarButton.h"

// Managers
#import "SRNotificationCenter.h"

@interface SRDiaporamaViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultController;
@property (strong, nonatomic) SRSelectionPickerBarButton *selectionPickerButton;
@property (strong, nonatomic) SRAddAndRemoveSelectionBarButton *selectionButton;

@end

@implementation SRDiaporamaViewController

#pragma mark - Constructor

+ (instancetype)newWithDirectory:(SRDirectory *)directory selectedImage:(SRImage *)selectedImage {
    return [[SRDiaporamaViewController alloc] initWithDirectory:directory selectedImage:selectedImage];
}

- (id)initWithDirectory:(SRDirectory *)directory selectedImage:(SRImage *)selectedImage {
    self = [super init];
    if (self) {
        self.directory = directory;
        self.selectedImage = selectedImage;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializePageViewController];
    [self setPageViewControllerForImage:self.selectedImage];
    
    [self initializeBarButtons];
    
    [self registerToModelNotifications];
}

#pragma mark - Initialization

- (void)initializeBarButtons {
    SRSelection *selection = [SRModel defaultModel].activeSelection;
    BOOL activeImageIsSelected = [selection imageIsSelected:self.selectedImage];
    self.selectionPickerButton = [[SRSelectionPickerBarButton alloc] initWithTarget:self action:@selector(selectionPickerButtonHandler) selection:selection];
    self.selectionButton = [[SRAddAndRemoveSelectionBarButton alloc] initWithTarget:self action:@selector(selectionButtonHandler) selected:activeImageIsSelected];
    self.navigationItem.rightBarButtonItems = @[self.selectionPickerButton, self.selectionButton];
}

#pragma mark - View updates

- (void)updateSelectionButton {
    
    SRSelection *selection = [SRModel defaultModel].activeSelection;
    if ([selection imageIsSelected:self.selectedImage]) {
        self.selectionButton.selected = YES;
    } else {
        self.selectionButton.selected = NO;
    }
}

#pragma mark - Getters & Setters

- (void)setDirectory:(SRDirectory *)directory {
    if (![directory isEqual:_directory]) {
        _directory = directory;
        [self updateFetchedResultController];
    }
}

#pragma mark - Handlers

- (void)selectionPickerButtonHandler {
    SRSelectionPopoverNavigationController *contentViewController = [SRSelectionPopoverNavigationController new];
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
    
    [contentViewController setCloseBlock:^{
        [popoverController dismissPopoverAnimated:YES];
    }];
    
    [popoverController presentPopoverFromBarButtonItem:self.selectionPickerButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)selectionButtonHandler {
    
    SRSelection *selection = [SRModel defaultModel].activeSelection;
    if ([selection imageIsSelected:self.selectedImage]) {
        [selection removeImagesObject:self.selectedImage];
    } else {
        [selection addImagesObject:self.selectedImage];
    }
    [self updateSelectionButton];
}

#pragma mark - Notifications

- (void)registerToModelNotifications {
    [[SRNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activeSelectionDidChangerNotificationHandler)
                                                 name:SRNotificationActiveSelectionChanged
                                               object:nil];
}

- (void)activeSelectionDidChangerNotificationHandler {
    self.selectionPickerButton.selection = [SRModel defaultModel].activeSelection;
    [self updateSelectionButton];
}

#pragma mark - Page view controller

- (void)initializePageViewController {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self addChildViewController:self.pageViewController];
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)updateFetchedResultController {
    self.fetchedResultController = [[SRModel defaultModel] fetchedResultControllerForImagesInDirectoryRecursively:self.directory];
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
}

- (void)setPageViewControllerForImage:(SRImage *)image {
    SRImageViewController *centerViewController = [SRImageViewController newWithImage:image];
    [self.pageViewController setViewControllers:@[centerViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
}

- (NSIndexPath *)indexPathForViewController:(UIViewController *)viewController {
    SRImage *image = ((SRImageViewController *)viewController).image;
    return [self.fetchedResultController indexPathForObject:image];
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSIndexPath *centerIndexPath = [self indexPathForViewController:viewController];
    
    if (centerIndexPath.row <= 0) return nil;
    
    NSIndexPath *beforeIndexPath = [NSIndexPath indexPathForRow:centerIndexPath.row-1 inSection:centerIndexPath.section];
    SRImage *image = [self.fetchedResultController objectAtIndexPath:beforeIndexPath];
    SRImageViewController *beforeViewController = [SRImageViewController newWithImage:image];
    return beforeViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSIndexPath *centerIndexPath = [self indexPathForViewController:viewController];
    
    NSIndexPath *afterIndexPath = [NSIndexPath indexPathForRow:centerIndexPath.row+1 inSection:centerIndexPath.section];
    
    if (centerIndexPath.row + 1 >= [self.fetchedResultController.fetchedObjects count]) return nil;
    
    SRImage *image = [self.fetchedResultController objectAtIndexPath:afterIndexPath];
    SRImageViewController *afterViewController = [SRImageViewController newWithImage:image];
    return afterViewController;
}

@end
