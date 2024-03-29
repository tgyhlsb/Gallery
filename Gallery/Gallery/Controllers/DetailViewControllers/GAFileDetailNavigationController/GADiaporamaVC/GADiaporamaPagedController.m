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
#import "GASettingsManager.h"

// Controllers
#import "GAFileInspectorVC.h"
#import "GADirectoryNavigationController.h"

#define PAGED_CONTROLLERS_CLASS GAFileInspectorVC

@interface GADiaporamaPagedController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) PAGED_CONTROLLERS_CLASS *centerViewController;

@property (strong, nonatomic) NSArray *topLeftBarItems;
@property (strong, nonatomic) NSArray *topRightBarItems;
@property (strong, nonatomic) NSArray *bottomLeftBarItems;
@property (strong, nonatomic) NSArray *bottomRightBarItems;

@end

@implementation GADiaporamaPagedController

#pragma mark - Constructors

+ (instancetype)newWithFiles:(NSArray *)files andSelectedImageFile:(GAImageFile *)imageFile {
    return [[GADiaporamaPagedController alloc] initWithFiles:files andSelectedImageFile:imageFile];
}


- (id)initWithFiles:(NSArray *)files andSelectedImageFile:(GAImageFile *)imageFile {
    self = [super init];
    if (self) {
        self.files = files;
        self.selectedImageFile = imageFile;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerToDirectoryInspectorsNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.selectedImageFile) {
        [self showImage:self.selectedImageFile];
    } else {
        [self showFiles:self.files];
    }
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

- (void)setBarItemDataSource:(id<GAFileInspectorBarButtonsDataSource>)barItemDataSource {
    _barItemDataSource = barItemDataSource;
    [self notifyDidChangeBarItems];
}

#pragma mark - BarItems

- (NSArray *)topRightBarItems {
    if (!_topRightBarItems) {
        _topRightBarItems = @[];
    }
    return _topRightBarItems;
}

#pragma mark - Broadcasting

- (void)registerToDirectoryInspectorsNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(directoryInspectorDidSelectDirectory:)
                                                 name:GANotificationFileNavigationDidSelectDirectory
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(directoryInspectorDidSelectImageFile:)
                                                 name:GANotificationFileNavigarionDidSelectImageFile
                                               object:nil];
}

#pragma mark - Handlers

- (void)directoryInspectorDidSelectDirectory:(NSNotification *)notification {
    GADirectory *directory = [notification.userInfo objectForKey:@"directory"];
    [self showFiles:directory.images];
}

- (void)directoryInspectorDidSelectImageFile:(NSNotification *)notification {
    GAImageFile *imageFile = [notification.userInfo objectForKey:@"imageFile"];
    [self showImage:imageFile];
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

- (void)showImage:(GAImageFile *)imageFile {
    PAGED_CONTROLLERS_CLASS *controller = [self dequeueControllerForFile:imageFile];
    [self setCenterViewController:controller animated:NO];
}

- (void)showFiles:(NSArray *)files {
    self.files = files;
    [self showImage:[files firstObject]];
}

- (void)reloadCenterViewController {
    [self setCenterViewController:self.centerViewController animated:NO];
}

- (void)showNext {
    GAFile *nextFile = [self getNextFile];
    if (nextFile) {
        PAGED_CONTROLLERS_CLASS *controller = [self dequeueControllerForFile:nextFile];
        [self setCenterViewController:controller animated:YES];
    }
}

- (void)showPrevious {
    GAFile *previousFile = [self getPreviousFile];
    if (previousFile) {
        PAGED_CONTROLLERS_CLASS *controller = [self dequeueControllerForFile:previousFile];
        [self setCenterViewController:controller animated:YES];
    }
}

- (GAFile *)getNextFile {
    NSInteger index = [self indexForImageFile:self.selectedImageFile];
    if (++index == self.files.count) index = 0; // Loop
    
    GAFile *file = [self.files objectAtIndex:index];
    return [file isEqual:self.selectedImageFile] ? nil : file;
}

- (GAFile *)getPreviousFile {
    NSInteger index = [self indexForImageFile:self.selectedImageFile];
    
    if (--index < 0) index = self.files.count-1; // Loop
    
    GAFile *file = [self.files objectAtIndex:index];
    return [file isEqual:self.selectedImageFile] ? nil : file;
}

- (NSInteger)indexForImageFile:(GAImageFile *)imageFile {
    if (![self.files containsObject:imageFile]) {
        [GALogger addError:@"Tried to acces image %@ which is not in diaporama", imageFile];
        return 0;
    } else {
        return [self.files indexOfObject:self.centerViewController.file];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    GAFile *file = [self getPreviousFile];
    if (!file) return nil;
    PAGED_CONTROLLERS_CLASS *beforeVC = [self dequeueControllerForFile:file];
    return beforeVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    GAFile *file = [self getNextFile];
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
    self.selectedImageFile = (GAImageFile *)centerViewController.file;
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
