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
#import "SRSelectionBarButtonItem.h"

// Managers
#import "SRNotificationCenter.h"

@interface SRDiaporamaViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, SRSelectionBarButtonItemDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultController;
@property (strong, nonatomic) SRSelectionBarButtonItem *selectionButton;

@end

@implementation SRDiaporamaViewController

#pragma mark - Constructor

+ (instancetype)newWithDirectory:(SRDirectory *)directory activeImage:(SRImage *)activeImage {
    return [[SRDiaporamaViewController alloc] initWithDirectory:directory activeImage:activeImage];
}

- (id)initWithDirectory:(SRDirectory *)directory activeImage:(SRImage *)activeImage {
    self = [super init];
    if (self) {
        self.directory = directory;
        self.activeImage = activeImage;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializePageViewController];
    [self setPageViewControllerForImage:self.activeImage];
    
    [self initializeBarButtons];
    
    [self registerToModelNotifications];
    
    [self setTitleWithAppIcon];
}

#pragma mark - Initialization

- (void)initializeBarButtons {
    SRSelection *selection = [SRModel defaultModel].activeSelection;
    BOOL activeImageIsSelected = [selection imageIsSelected:self.activeImage];
    self.selectionButton = [[SRSelectionBarButtonItem alloc] initWithDelegate:self selection:selection selected:activeImageIsSelected];
    self.navigationItem.rightBarButtonItems = @[self.selectionButton];
}

#pragma mark - View updates

- (void)updateSelectionButton {
    
    SRSelection *selection = [SRModel defaultModel].activeSelection;
    if ([selection imageIsSelected:self.activeImage]) {
        self.selectionButton.selected = YES;
    } else {
        self.selectionButton.selected = NO;
    }
    self.selectionButton.selection = selection;
}

#pragma mark - Getters & Setters

- (void)setDirectory:(SRDirectory *)directory {
    if (![directory isEqual:_directory]) {
        _directory = directory;
        [self updateFetchedResultController];
    }
}

- (void)setActiveImage:(SRImage *)selectedImage {
    _activeImage = selectedImage;
}

#pragma mark - Handlers

- (void)addAndRemoveButtonHandler:(SRSelectionBarButtonItem *)sender {
    
    SRSelection *selection = [SRModel defaultModel].activeSelection;
    if ([selection imageIsSelected:self.activeImage]) {
        [selection deselectImage:self.activeImage];
    } else {
        [selection selectImage:self.activeImage];
    }
    [self updateSelectionButton];
}

- (void)selectionPickerButtonHandler:(SRSelectionBarButtonItem *)sender {
    SRSelectionPopoverNavigationController *contentViewController = [SRSelectionPopoverNavigationController new];
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
    
    [contentViewController setCloseBlock:^{
        [popoverController dismissPopoverAnimated:YES];
    }];
    
    [popoverController presentPopoverFromBarButtonItem:self.selectionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Notifications

- (void)registerToModelNotifications {
    [[SRNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activeSelectionDidChangerNotificationHandler)
                                                 name:SRNotificationActiveSelectionChanged
                                               object:nil];
}

- (void)activeSelectionDidChangerNotificationHandler {
    self.selectionButton.selection = [SRModel defaultModel].activeSelection;
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

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    SRImageViewController *centerViewController = [pageViewController.viewControllers lastObject];
    self.activeImage = centerViewController.image;
    [self updateSelectionButton];
}

@end
