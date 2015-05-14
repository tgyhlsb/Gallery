//
//  GAImageCollectionNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 14/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageCollectionNavigationController.h"

// Controllers
#import "GAImageCollectionViewController.h"
#import "GASettingsSplitController.h"


@interface GAImageCollectionNavigationController ()

@property (strong, nonatomic) UIBarButtonItem *settingsButton;

@end

@implementation GAImageCollectionNavigationController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)directory {
    GAImageCollectionViewController *controller = [GAImageCollectionViewController newWithRootDirectory:directory];
    return [[GAImageCollectionNavigationController alloc] initWithRootViewController:controller];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.toolbarHidden = NO;
        rootViewController.toolbarItems = @[self.settingsButton];
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

#pragma mark - Configuration

#pragma mark - Getters & Setters

- (GAImageCollectionViewController *)rootViewController {
    return [self.viewControllers firstObject];
}

- (UIBarButtonItem *)settingsButton {
    if (!_settingsButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_SETTINGS", nil);
        _settingsButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(settingsButtonHandler)];
    }
    return _settingsButton;
}

#pragma mark - Handlers

- (void)settingsButtonHandler {
    [self presentViewController:[GASettingsSplitController new] animated:YES completion:^{
        
    }];
}

@end
