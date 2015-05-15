//
//  SRFilesTableViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "UICoreDataTableViewController.h"

// Models
#import "SRModel.h"

@interface SRFilesTableViewController : UICoreDataTableViewController

+ (instancetype)newWithDirectory:(SRDirectory *)directory;

@end
