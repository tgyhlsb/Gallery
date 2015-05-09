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

@end

@implementation GADirectorySplitController

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        GADirectory *rootDirectory = [GAFileManager readSharedDirectory];
        
        GADirectoryNavigationController *mainVC = [GADirectoryNavigationController newWithRootDirectory:rootDirectory];
        GAFileDetailNavigationController *detailVC = [GAFileDetailNavigationController new];
        
        self.viewControllers = @[mainVC, detailVC];
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.delegate = [detailVC rootViewController];
        self.presentsWithGesture = NO;
    }
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters


@end
