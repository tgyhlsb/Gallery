//
//  GADiaporamaVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controllers

// Models
#import "GAImageFile.h"
#import "GADirectory.h"

@interface GADiaporamaVC : UIViewController

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile;

- (void)setRootDirectory:(GADirectory *)rootDirectory withImageFile:(GAImageFile *)imageFile;

@end
