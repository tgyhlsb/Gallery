//
//  GAFileLoadingVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFileLoadingVC.h"

// Managers
#import "GAFileManager.h"

@interface GAFileLoadingVC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GAFileLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator.hidesWhenStopped = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startProcessing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Processing

- (void)startProcessing {
    [self.activityIndicator startAnimating];
    [GAFileManager readSharedDirectoryInBackgroundWithBlock:^(GADirectory *root, NSError *error) {
        if (root && !error) {
            [self performSelector:@selector(didEndProcessing)];
        }
    }];
}

- (void)didEndProcessing {
    [self.activityIndicator stopAnimating];
    if (self.completionBLock) self.completionBLock();
}

@end
