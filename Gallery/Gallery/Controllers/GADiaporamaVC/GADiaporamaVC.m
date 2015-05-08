//
//  GADiaporamaVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADiaporamaVC.h"

#import "GARightVC.h"

@interface GADiaporamaVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

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

- (void)setRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile {
    GARightVC *vc = [GARightVC new];
    vc.imageFile = imageFile;
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

#pragma mark - UIPageViewControllerDelegate

@end
