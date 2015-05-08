//
//  GASplitVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASplitVC.h"

// Models
#import "GAFileManager.h"

// Controllers
#import "GADirectoryNavigationController.h"
#import "GARightNavigationVC.h"


@interface GASplitVC ()

@end

@implementation GASplitVC

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        
        GADirectory *rootDirectory = [GAFileManager readSharedDirectory];
        GADirectoryNavigationController *mainVC = [GADirectoryNavigationController newWithRootDirectory:rootDirectory];
        GARightNavigationVC *detailVC = [GARightNavigationVC new];
        
        [mainVC rootViewController].delegate = [detailVC rootViewController];
        
        self.viewControllers = @[mainVC, detailVC];
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
