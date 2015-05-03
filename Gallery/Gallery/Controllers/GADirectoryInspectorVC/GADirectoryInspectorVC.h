//
//  GADirectoryInspectorVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GADirectory.h"

@interface GADirectoryInspectorVC : UITableViewController

@property (strong, nonatomic) GADirectory *directory;

+ (instancetype)newWithDirectory:(GADirectory *)directory;

@end
