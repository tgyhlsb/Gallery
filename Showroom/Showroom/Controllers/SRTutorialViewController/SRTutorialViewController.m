//
//  SRTutorialViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 21/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRTutorialViewController.h"

// Controllers
#import "SRTutorialSlideViewController.h"

@interface SRTutorialViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) SRTutorialSlideViewController *centerViewController;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *messages;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation SRTutorialViewController

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        self.images = @[
                        [UIImage imageNamed:@"banner.png"],
                        [UIImage imageNamed:@"banner.png"],
                        [UIImage imageNamed:@"banner.png"],
                        [UIImage imageNamed:@"banner.png"],
                        [UIImage imageNamed:@"banner.png"]
                        ];
        
        self.messages = @[
                          @"1",
                          @"2",
                          @"3",
                          @"4",
                          @"5"
                          ];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializePageViewController];
    [self setPageViewControllerForIndex:0];
    
    self.toolBar.barTintColor = [UIColor colorWithRed:0.12f green:0.45f blue:0.66f alpha:1.00f];
    self.toolBar.tintColor = [UIColor whiteColor];
    
    [self.closeButton setTitle:NSLocalizedString(@"LOCALIZE_CLOSE", nil)];
    
    self.pageControl.numberOfPages = self.images.count;
    
    UIImage *macImage = [UIImage imageNamed:@"mac.png"];
    UIImage *windowsImage = [UIImage imageNamed:@"windows.png"];
    [self.segmentedControl setImage:macImage forSegmentAtIndex:0];
    [self.segmentedControl setImage:windowsImage forSegmentAtIndex:1];
}

#pragma mark - Getters & Setters

- (void)setCenterViewController:(SRTutorialSlideViewController *)centerViewController {
    _centerViewController = centerViewController;
    self.pageControl.currentPage = [self indexForViewController:centerViewController];
}

#pragma mark - Handlers

- (IBAction)closeButtonHandler {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Page view controller

- (void)initializePageViewController {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self addChildViewController:self.pageViewController];
    self.pageViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (SRTutorialSlideViewController *)dequeueViewControllerForIndex:(NSInteger)index {
    SRTutorialSlideViewController *newController = [[SRTutorialSlideViewController alloc] init];
    newController.index = index;
    newController.image = [self.images objectAtIndex:index];
    newController.message = [self.messages objectAtIndex:index];
    return newController;
}

- (void)setPageViewControllerForIndex:(NSInteger)index {
    SRTutorialSlideViewController *centerViewController = [self dequeueViewControllerForIndex:index];
    __weak SRTutorialViewController *weakSelf = self;
    [self.pageViewController setViewControllers:@[centerViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        if (finished) weakSelf.centerViewController = centerViewController;
    }];
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    NSInteger index = ((SRTutorialSlideViewController *)viewController).index;
    return index;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger beforeIndex = [self indexForViewController:viewController] - 1;
    
    if (beforeIndex < 0) return nil;
    
    SRTutorialSlideViewController *beforeController = [self dequeueViewControllerForIndex:beforeIndex];
    return beforeController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger afterIndex = [self indexForViewController:viewController] + 1;
    
    if (afterIndex >= self.images.count) return nil;
    
    SRTutorialSlideViewController *afterController = [self dequeueViewControllerForIndex:afterIndex];
    return afterController;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (finished && completed) {
        self.centerViewController = [pageViewController.viewControllers lastObject];
    }
}

@end
