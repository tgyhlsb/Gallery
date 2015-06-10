//
//  SRSelection.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRImage;

@interface SRSelection : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * modificationDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *images;
@end

@interface SRSelection (CoreDataGeneratedAccessors)

- (void)addImagesObject:(SRImage *)value;
- (void)removeImagesObject:(SRImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
