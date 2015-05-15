//
//  SRModel.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// Models
#import "SRFile+Helper.h"
#import "SRDirectory+Helper.h"
#import "SRImage+Helper.h"

@interface SRModel : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SRModel *)defaultModel;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#define Request factory
- (NSFetchedResultsController *)fetchedResultControllerForFilesInDirectory:(SRDirectory *)directory;

@end
