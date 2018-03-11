//
//  SRFilesNavigationController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "SRModel.h"

@interface SRFilesNavigationController : UINavigationController

+ (instancetype)newWithDirectory:(SRDirectory *)directory;

@end
