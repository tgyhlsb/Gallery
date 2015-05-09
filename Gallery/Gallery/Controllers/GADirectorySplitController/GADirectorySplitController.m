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

- (id)init {
    self = [super init];
    if (self) {
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.presentsWithGesture = NO;
    }
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setInterfaceForRootDirectory:[GAFileManager rootDirectory]];
    [self registerToFileMangerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getters & Setters

- (void)setInterfaceForRootDirectory:(GADirectory *)rootDirectory {
    
    self.masterNavigationController = [GADirectoryNavigationController newWithRootDirectory:rootDirectory];
    self.detailNavigationController = [GAFileDetailNavigationController new];
    
    self.viewControllers = @[self.masterNavigationController, self.detailNavigationController];
    self.delegate = [self.detailNavigationController rootViewController];
}

#pragma mark - Broadcast

- (void)registerToFileMangerNotifications {
    [GAFileManager startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileDirectoryDidChange) name:GANotificationFileDirectoryChanged object:nil];
}

- (void)fileDirectoryDidChange {
    self.masterNavigationController.toolbar.tintColor = [UIColor redColor];
}


@end
