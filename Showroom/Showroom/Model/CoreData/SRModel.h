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
#import "SRSelection+Helper.h"

@interface SRModel : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SRModel *)defaultModel;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - Request factory
- (NSFetchedResultsController *)fetchedResultControllerForFilesInDirectory:(SRDirectory *)directory;
- (NSFetchedResultsController *)fetchedResultControllerForImagesInDirectory:(SRDirectory *)directory recursively:(BOOL)recursively;
- (NSFetchedResultsController *)fetchedResultControllerForImagesInSelection:(SRSelection *)selection;
- (NSFetchedResultsController *)fetchedResultControllerForDirectoriesInDirectoryRecursively:(SRDirectory *)directory;
- (NSFetchedResultsController *)fetchedResultControllerForSelections;
- (NSFetchedResultsController *)fetchedResultControllerForSelectionsActive:(BOOL)active;

#pragma mark - Selections

@property (readwrite, strong, nonatomic) SRSelection *activeSelection;

- (void)fetchActiveSelection;

- (SRSelection *)createSelectionWithTitle:(NSString *)title;


@end
