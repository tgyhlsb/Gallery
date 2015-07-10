//
//  SRTutorialSelectionsViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/07/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRTutorialSelectionsViewController.h"

@interface SRTutorialSelectionsViewController ()

@end

@implementation SRTutorialSelectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"LOCALIZE_TUTORIAL_SELECTIONS_TITLE", nil);
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Content configuration

- (void)configureContent {
    
    
    NSArray *macImages = @[
                           [UIImage imageNamed:@"AddFiles_mac_step1.png"],
                           [UIImage imageNamed:@"AddFiles_mac_step2.png"],
                           [UIImage imageNamed:@"AddFiles_mac_step3.png"],
                           [UIImage imageNamed:@"AddFiles_mac_step4.png"],
                           [UIImage imageNamed:@"AddFiles_mac_step5.png"]
                           ];
    
    NSArray *windowsImages = @[
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"]
                               ];
    
    NSArray *macMessages = @[
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_ADDFILES_STEP1", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_ADDFILES_STEP2", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_ADDFILES_STEP3", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_ADDFILES_STEP4", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_ADDFILES_STEP5", nil),
                             ];
    
    NSArray *windowsMessages = @[
                                 @"1",
                                 @"2",
                                 @"3",
                                 @"4",
                                 @"5"
                                 ];
    
    self.images = @[macImages, windowsImages];
    
    self.messages = @[macMessages, windowsMessages];
}

@end
