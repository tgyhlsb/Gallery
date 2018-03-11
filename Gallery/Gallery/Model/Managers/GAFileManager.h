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
// Blocks
typedef void (^GAFileReadingCompletionBlock)(GADirectory *root, NSError *error);

static NSString *GANotificationFileDirectoryChanged = @"GANotificationFileDirectoryChanged";

@interface GAFileManager : NSObject

+ (void)startMonitoring;
+ (void)stopMonitoring;

+ (GADirectory *)rootDirectory;
+ (GADirectory *)readSharedDirectory;
+ (void)readSharedDirectoryInBackgroundWithBlock:(GAFileReadingCompletionBlock)block;

@end
