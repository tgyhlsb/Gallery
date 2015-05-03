//
//  GAFileManager.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

// Models
#import "GADirectory.h"

@interface GAFileManager : NSObject

+ (GADirectory *)rootDirectory;
+ (GADirectory *)readSharedDirectory;

@end
