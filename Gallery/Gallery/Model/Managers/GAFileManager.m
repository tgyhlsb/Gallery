//
//  GAFileManager.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFileManager.h"

// Managers
#import "GALogger.h"

static GAFileManager *sharedManager;

@interface GAFileManager()

@property (strong, nonatomic) GADirectory *rootDirectory;

@end

@implementation GAFileManager

#pragma mark - Singleton

+ (GAFileManager *)sharedManager {
    if (!sharedManager) sharedManager = [GAFileManager new];
    return sharedManager;
}

+ (GADirectory *)readSharedDirectory {
    return [[GAFileManager sharedManager] readSharedDirectory];
}

+ (GADirectory *)rootDirectory {
    return [[GAFileManager sharedManager] rootDirectory];
}

#pragma mark - Methods

- (GADirectory *)readSharedDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *publicDocumentsDir = [paths objectAtIndex:0];
    [GALogger addInformation:@"%@", publicDocumentsDir];
    self.rootDirectory = [GADirectory directoryFromPath:publicDocumentsDir parent:nil];
    
    return self.rootDirectory;
}

@end
