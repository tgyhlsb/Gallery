//
//  SRSelection.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRImage;

@interface SRSelection : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * modificationDate;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSOrderedSet *images;
@end

@interface SRSelection (CoreDataGeneratedAccessors)

- (void)insertObject:(SRImage *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(SRImage *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray *)values;
- (void)addImagesObject:(SRImage *)value;
- (void)removeImagesObject:(SRImage *)value;
- (void)addImages:(NSOrderedSet *)values;
- (void)removeImages:(NSOrderedSet *)values;
@end
