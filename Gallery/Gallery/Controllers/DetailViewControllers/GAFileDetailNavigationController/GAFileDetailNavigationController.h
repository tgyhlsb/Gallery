//
//  GAFileDetailNavigationController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GADirectory.h"

// Controllers
#import "GADiaporamaVC.h"
#import "GADirectoryNavigationController.h"

@interface GAFileDetailNavigationController : UINavigationController

+ (instancetype)newWithDirectory:(GADirectory *)directory;

- (GADiaporamaVC *)rootViewController;

@end
