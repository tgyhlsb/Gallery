//
//  SRModel.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRModel.h"

// Models
#import "SRFile+Serializer.h"
#import "SRDirectory.h"
#import "SRSelection+Serializer.h"

// Managers
#import "SRLogger.h"
#import "SRNotificationCenter.h"

@implementation SRModel

#pragma mark - Singleton

static SRModel *defaultModel;

+ (SRModel *)defaultModel {
    if (!defaultModel) {
        defaultModel = [[SRModel alloc] init];
    }
    return defaultModel;
}

#pragma mark - Sort descriptor factory

- (NSSortDescriptor *)fileSortDescriptor {
    return[NSSortDescriptor sortDescriptorWithKey:@"name"
                                        ascending:YES
                                         selector:@selector(compare:)];
}

- (NSSortDescriptor *)imageSortDescriptor {
    return[NSSortDescriptor sortDescriptorWithKey:@"name"
                                        ascending:YES
                                         selector:@selector(compare:)];
}

- (NSSortDescriptor *)directorySortDescriptor {
    return[NSSortDescriptor sortDescriptorWithKey:@"path"
                                        ascending:YES
                                         selector:@selector(compare:)];
}

- (NSSortDescriptor *)parentSortDescriptor {
    return[NSSortDescriptor sortDescriptorWithKey:@"parent.path"
                                        ascending:YES
                                         selector:@selector(compare:)];
}

- (NSSortDescriptor *)selectionSortDescriptor {
    return[NSSortDescriptor sortDescriptorWithKey:@"modificationDate"
                                        ascending:YES
                                         selector:@selector(compare:)];
}

#pragma mark - Request factory

- (NSFetchedResultsController *)fetchedResultControllerForFilesInDirectory:(SRDirectory *)directory {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRFile className]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", directory];
    
    request.sortDescriptors = @[[self fileSortDescriptor]];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultControllerForImagesInDirectory:(SRDirectory *)directory recursively:(BOOL)recursively {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRImage className]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"path contains[cd] %@", directory.path];
    
    request.sortDescriptors = @[[self parentSortDescriptor], [self imageSortDescriptor]];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:@"parent.path"
                                                          cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultControllerForImagesInSelection:(SRSelection *)selection {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRImage className]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"ANY selections = %@", selection];
    
    request.sortDescriptors = @[[self parentSortDescriptor], [self imageSortDescriptor]];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:@"parent.path"
                                                          cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultControllerForDirectoriesInDirectoryRecursively:(SRDirectory *)directory {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRDirectory className]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"path contains[cd] %@", directory.path];
    
    request.sortDescriptors = @[[self directorySortDescriptor]];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}


- (NSFetchedResultsController *)fetchedResultControllerForSelections {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRSelection className]];
    
    request.sortDescriptors = @[[self selectionSortDescriptor]];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultControllerForSelectionsActive:(BOOL)active {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRSelection className]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"active = %@", @(active)];
    
    request.sortDescriptors = @[[self selectionSortDescriptor]];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

#pragma mark - Selections

- (void)setActiveSelection:(SRSelection *)activeSelection {
    if (![_activeSelection isEqual:activeSelection]) {
        [_activeSelection setIsActive:NO];
        _activeSelection = activeSelection;
        [_activeSelection setIsActive:YES];
        [self notifyActiveSelectionDidChange];
    }
}

- (void)fetchActiveSelection {
    NSFetchedResultsController *fetchedResultController = [self fetchedResultControllerForSelectionsActive:YES];
    NSError *error = nil;
    [fetchedResultController performFetch:&error];
    if (error) {
        [SRLogger addError:@"Failed to fetch active selection: %@", error];
    } else {
        if (fetchedResultController.fetchedObjects.count == 0) {
            self.activeSelection = nil;
        } else if (fetchedResultController.fetchedObjects.count == 1) {
            self.activeSelection = [fetchedResultController.fetchedObjects firstObject];
        } else {
            [SRLogger addError:@"More than one active selection fetched: %@", fetchedResultController.fetchedObjects];
            self.activeSelection = nil;
        }
        [self notifyActiveSelectionDidChange];
    }
}

- (void)notifyActiveSelectionDidChange {
    [[SRNotificationCenter defaultCenter] postNotificationName:SRNotificationActiveSelectionChanged object:nil];
}

- (SRSelection *)createSelectionWithTitle:(NSString *)title {
    SRSelection *selection = [SRSelection selectionWithTitle:title inManagedObjectContext:self.managedObjectContext];
    self.activeSelection = selection;
    [self saveContext];
    return selection;
}

- (void)deleteSelection:(SRSelection *)selection {
    [self.managedObjectContext deleteObject:selection];
    if ([self.activeSelection isEqual:selection]) self.activeSelection = nil;
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.helesbeux.Showroom" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Showroom" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [self storeURL];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [self resetStore];
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (NSURL *)storeURL {
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Showroom.sqlite"];
}

- (void)resetStore {
    NSURL *storeURL = [self storeURL];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    _persistentStoreCoordinator = [self persistentStoreCoordinator];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges]) {
            
            NSError *error = nil;
            [managedObjectContext save:&error];
            
            if (error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                if (error.code == 134100) { // Replace 0 by invalid model error code
                    [self resetStore];
                    [self saveContext];
                } else {
                    abort();
                }
            }
        }
    }
}

@end
