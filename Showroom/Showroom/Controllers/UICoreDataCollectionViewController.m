//
//  UICoreDataCollectionViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "UICoreDataCollectionViewController.h"

@interface UICoreDataCollectionViewController()

@property (strong, nonatomic) NSMutableArray *sectionModifications;
@property (strong, nonatomic) NSMutableArray *itemModifications;

@end

@implementation UICoreDataCollectionViewController

- (NSString *)titleForSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        BOOL success = [self.fetchedResultsController performFetch:&error];
        if (!success) NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.collectionView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch];
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        return [self collectionView:collectionView viewForHeaderAtIndexPath:indexPath];
    } else if (kind == UICollectionElementKindSectionFooter) {
        return [self collectionView:collectionView viewForFooterAtIndexPath:indexPath];
    } else {
        return nil;
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - NSFetchedResultsControllerDelegate

#define KEY_SECTION_INDEX @"sectionIndex"
#define KEY_CHANGE_TYPE @"changeType"
#define KEY_NEW_INDEXPATH @"newIndexPath"
#define KEY_OLD_INDEXPATH @"oldIndexPath"

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.sectionModifications = [[NSMutableArray alloc] init];
    self.itemModifications = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    
    [self.sectionModifications addObject:@{
                                           KEY_SECTION_INDEX: @(sectionIndex),
                                           KEY_CHANGE_TYPE: @(type)
                                           }];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeMove) {
        [self.itemModifications addObject:@{
                                               KEY_NEW_INDEXPATH: newIndexPath,
                                               KEY_OLD_INDEXPATH: indexPath,
                                               KEY_CHANGE_TYPE: @(type)
                                               }];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.itemModifications addObject:@{
                                            KEY_OLD_INDEXPATH: indexPath,
                                            KEY_CHANGE_TYPE: @(type)
                                            }];
    } else {
        [self.itemModifications addObject:@{
                                               KEY_NEW_INDEXPATH: newIndexPath,
                                               KEY_CHANGE_TYPE: @(type)
                                               }];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"fuck");
    [self performChanges];
}

- (void)performChanges {
    
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in self.sectionModifications) {
            [self performSectionChange:change];
        }
        for (NSDictionary *change in self.itemModifications) {
            [self performItemChange:change];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            self.sectionModifications = nil;
            self.itemModifications = nil;
        }
    }];
}

- (void)performItemChange:(NSDictionary *)change {
    
    NSFetchedResultsChangeType type = [[change objectForKey:KEY_CHANGE_TYPE] integerValue];
    NSIndexPath *newIndexPath = [change objectForKey:KEY_NEW_INDEXPATH];
    NSIndexPath *indexPath = [change objectForKey:KEY_OLD_INDEXPATH];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
    }
}

- (void)performSectionChange:(NSDictionary *)change {
    
    NSFetchedResultsChangeType type = [[change objectForKey:KEY_CHANGE_TYPE] integerValue];
    NSInteger sectionIndex = [[change objectForKey:KEY_SECTION_INDEX] integerValue];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.collectionView reloadData];
            break;
    }
}

@end
