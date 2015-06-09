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

// Model
#import "SRModel.h"

// Views
#import "SRSelectionPickerBarButton.h"

@interface SRDiaporamaViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultController;
@property (strong, nonatomic) SRSelectionPickerBarButton *selectionPickerButton;

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
    
    self.selectionPickerButton = [[SRSelectionPickerBarButton alloc] initWithTarget:self action:@selector(selectionPickerHandler)];
    self.toolbarItems = @[self.selectionPickerButton];
}

#pragma mark - Getters & Setters

- (void)setDirectory:(SRDirectory *)directory {
    if (![directory isEqual:_directory]) {
        _directory = directory;
        [self updateFetchedResultController];
    }
}

#pragma mark - Handlers

- (void)selectionPickerHandler {
    
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
