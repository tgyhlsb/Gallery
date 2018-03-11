//
//  GAImageCollectionViewController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GADirectory.h"

@interface GAImageCollectionViewController : UIViewController

+ (instancetype)newWithRootDirectory:(GADirectory *)directory;

@end
