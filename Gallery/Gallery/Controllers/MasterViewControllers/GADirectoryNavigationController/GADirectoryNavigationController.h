//
//  GADirectoryNavigationController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controllers
#import "GADirectoryMasterVC.h"

// Models
#import "GADirectory.h"

@interface GADirectoryNavigationController : UINavigationController

+ (instancetype)newWithRootDirectory:(GADirectory *)directory;

- (GADirectoryMasterVC *)rootViewController;

@end

