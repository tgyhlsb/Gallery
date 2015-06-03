//
//  GADirectory.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GAFile.h"

@class GADirectory, GAImage;

@interface GADirectory : GAFile

@property (nonatomic, retain) NSOrderedSet *images;
@property (nonatomic, retain) GADirectory *parent;
@property (nonatomic, retain) NSOrderedSet *subDirectories;
@end

@interface GADirectory (CoreDataGeneratedAccessors)

- (void)insertObject:(GAImage *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(GAImage *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray *)values;
- (void)addImagesObject:(GAImage *)value;
- (void)removeImagesObject:(GAImage *)value;
- (void)addImages:(NSOrderedSet *)values;
- (void)removeImages:(NSOrderedSet *)values;
- (void)insertObject:(GADirectory *)value inSubDirectoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubDirectoriesAtIndex:(NSUInteger)idx;
- (void)insertSubDirectories:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubDirectoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubDirectoriesAtIndex:(NSUInteger)idx withObject:(GADirectory *)value;
- (void)replaceSubDirectoriesAtIndexes:(NSIndexSet *)indexes withSubDirectories:(NSArray *)values;
- (void)addSubDirectoriesObject:(GADirectory *)value;
- (void)removeSubDirectoriesObject:(GADirectory *)value;
- (void)addSubDirectories:(NSOrderedSet *)values;
- (void)removeSubDirectories:(NSOrderedSet *)values;
@end
