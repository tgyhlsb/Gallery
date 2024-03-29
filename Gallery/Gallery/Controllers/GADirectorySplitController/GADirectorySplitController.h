//
//  GASplitVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GADirectory.h"

@interface GADirectorySplitController : UISplitViewController

+ (instancetype)newWithRootDirectory:(GADirectory *)directory;

@end
