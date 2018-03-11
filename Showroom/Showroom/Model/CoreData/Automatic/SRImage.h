//
//  SRImage.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SRFile.h"

@class SRSelection;

@interface SRImage : SRFile

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSSet *selections;
@end

@interface SRImage (CoreDataGeneratedAccessors)

- (void)addSelectionsObject:(SRSelection *)value;
- (void)removeSelectionsObject:(SRSelection *)value;
- (void)addSelections:(NSSet *)values;
- (void)removeSelections:(NSSet *)values;

@end
