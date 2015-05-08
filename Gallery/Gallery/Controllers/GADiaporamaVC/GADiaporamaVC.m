//
//  GADiaporamaVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADiaporamaVC.h"

#import "GARightVC.h"

// Models
#import "GAImageFile.h"
#import "GADirectory.h"

// Others
#import "NSMutableArray+GAStack.h"

#define PAGED_CONTROLLERS_CLASS GARightVC

@interface GADiaporamaVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

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
    
    UIViewController *red = [UIViewController new];
    red.view.backgroundColor = [UIColor redColor];
    
    UIViewController *blue = [UIViewController new];
    blue.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *green = [UIViewController new];
    green.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *yellow = [UIViewController new];
    yellow.view.backgroundColor = [UIColor yellowColor];
    
    [self.pageViewController setViewControllers:@[red]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSMutableArray *)viewControllersStack {
    if (!_viewControllersStack) _viewControllersStack = [NSMutableArray new];
    return _viewControllersStack;
}

- (void)setRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile {
    PAGED_CONTROLLERS_CLASS *vc = [PAGED_CONTROLLERS_CLASS new];
    vc.imageFile = imageFile;
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (PAGED_CONTROLLERS_CLASS *)dequeueViewController {
    PAGED_CONTROLLERS_CLASS *viewController = [self.viewControllersStack pop];
    NSLog(@"Poped");
    if (!viewController) {
        viewController = [PAGED_CONTROLLERS_CLASS new];
        NSLog(@"Created");
    }
    return viewController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    PAGED_CONTROLLERS_CLASS *beforeVC = [self dequeueViewController];
    PAGED_CONTROLLERS_CLASS *activeVC = ((PAGED_CONTROLLERS_CLASS *)viewController);
    GAFile *previousFile = activeVC.imageFile.previous;
    beforeVC.imageFile = previousFile.isImage ? (GAImageFile *)previousFile : nil;
    return beforeVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PAGED_CONTROLLERS_CLASS *afterVC = [self dequeueViewController];
    PAGED_CONTROLLERS_CLASS *activeVC = ((PAGED_CONTROLLERS_CLASS *)viewController);
    GAFile *nextFile = activeVC.imageFile.next;
    afterVC.imageFile = nextFile.isImage ? (GAImageFile *)nextFile : nil;
    return afterVC;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if (finished && completed) {
        [self.viewControllersStack push:[previousViewControllers firstObject]];
        NSLog(@"Pushed");
    }
}

@end
