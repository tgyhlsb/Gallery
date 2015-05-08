//
//  GADiaporamaVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controllers
#import "GADirectoryInspectorVC.h"

// Models
#import "GAImageFile.h"
#import "GADirectory.h"

@interface GADiaporamaVC : UIViewController <GADirectoryInspectorDelegate, UISplitViewControllerDelegate>

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile;

- (void)setRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile;

@end