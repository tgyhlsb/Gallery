//
//  GAImageCollectionNavigationController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 14/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GAFileNavigator.h"

@interface GAImageCollectionNavigationController : UINavigationController

+ (instancetype)newWithFileNavigator:(GAFileNavigator *)fileNavigator;

@end
