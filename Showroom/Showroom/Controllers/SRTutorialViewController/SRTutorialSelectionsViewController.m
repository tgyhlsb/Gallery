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
                           [UIImage imageNamed:@"Lists_step1.png"],
                           [UIImage imageNamed:@"Lists_step2.png"],
                           [UIImage imageNamed:@"Lists_step3.png"],
                           [UIImage imageNamed:@"Lists_step4.png"],
                           [UIImage imageNamed:@"Lists_step5.png"],
                           [UIImage imageNamed:@"Lists_step6.png"],
                           ];
    
    NSArray *windowsImages = @[
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"],
                               [UIImage imageNamed:@"banner.png"]
                               ];
    
    NSArray *macMessages = @[
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_LISTS_STEP1", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_LISTS_STEP2", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_LISTS_STEP3", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_LISTS_STEP4", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_LISTS_STEP5", nil),
                             NSLocalizedString(@"LOCALIZE_TUTORIAL_LISTS_STEP6", nil)
                             ];
    
    NSArray *windowsMessages = @[
                                 @"1",
                                 @"2",
                                 @"3",
                                 @"4",
                                 @"5",
                                 @"6"
                                 ];
    
    self.images = @[macImages, windowsImages];
    
    self.messages = @[macMessages, windowsMessages];
}

@end
