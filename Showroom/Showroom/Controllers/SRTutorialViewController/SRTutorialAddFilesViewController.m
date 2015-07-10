//
//  SRTutorialAddFilesViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/07/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRTutorialAddFilesViewController.h"

@interface SRTutorialAddFilesViewController ()

@end

@implementation SRTutorialAddFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"LOCALIZE_TUTORIAL_ADDFILES_TITLE", nil);
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
                             @"1",
                             @"2",
                             @"3",
                             @"4",
                             @"5"
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
