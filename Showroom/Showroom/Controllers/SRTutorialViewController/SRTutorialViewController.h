//
//  SRTutorialViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 21/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRViewController.h"
#import "SRNavigationController.h"

@interface SRTutorialViewController : SRViewController

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *messages;

+ (SRNavigationController *)tutorialNavigationController;
+ (SRNavigationController *)navigationControllerForRootViewController:(SRTutorialViewController *)rootController;

@end
