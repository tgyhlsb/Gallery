//
//  GASplitVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectorySplitController.h"

// Models
#import "GAFileManager.h"

// Controllers
#import "GADirectoryNavigationController.h"
#import "GAFileDetailNavigationController.h"


@interface GADirectorySplitController ()

@property (strong, nonatomic) GADirectoryNavigationController *masterNavigationController;
@property (strong, nonatomic) GAFileDetailNavigationController *detailNavigationController;

@end

@implementation GADirectorySplitController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)directory {
    return [[GADirectorySplitController alloc] initWithRootDirectory:directory];
}

- (id)initWithRootDirectory:(GADirectory *)directory {
    self = [super init];
    if (self) {
        
        self.masterNavigationController = [GADirectoryNavigationController newWithRootDirectory:directory];
        self.detailNavigationController = [GAFileDetailNavigationController newWithDirectory:directory];
        
        self.viewControllers = @[self.masterNavigationController, self.detailNavigationController];
        self.delegate = [self.detailNavigationController rootViewController];
        
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.presentsWithGesture = NO;
    }
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getters & Setters


@end
