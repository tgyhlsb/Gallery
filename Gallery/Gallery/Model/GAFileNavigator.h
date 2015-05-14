//
//  GAFileNavigator.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 14/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

// Models
#import "GAFile+Pointers.h"

@protocol GAFileNavigatorDelegate;

static NSString *GANotificationFileNavigatorDidSelectDirectory = @"GANotificationFileNavigatorDidSelectDirectory";
static NSString *GANotificationFileNavigatorDidSelectImageFile = @"GANotificationFileNavigatorDidSelectImageFile";

@interface GAFileNavigator : NSObject

@property (weak, nonatomic) id<GAFileNavigatorDelegate> delegate;

@property (nonatomic) BOOL canNavigateBetweenDirectories;

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory;

- (void)setDirectory:(GADirectory *)directory;
- (void)setFile:(GAFile *)file;
- (void)selectFile:(GAFile *)file;
- (GAFile *)getFile;
- (GAFile *)getNextFile;
- (GAFile *)getPreviousFile;
- (GADirectory *)getRootDirectory;

@end

@protocol GAFileNavigatorDelegate <NSObject>

- (void)fileNavigator:(GAFileNavigator *)fileNavigator didSelectFile:(GAFile *)file;

@end
