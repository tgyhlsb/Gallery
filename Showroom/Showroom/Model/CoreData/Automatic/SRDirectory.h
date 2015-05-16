//
//  SRDirectory.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SRFile.h"

@class SRFile;

@interface SRDirectory : SRFile

@property (nonatomic, retain) NSSet *children;
@end

@interface SRDirectory (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(SRFile *)value;
- (void)removeChildrenObject:(SRFile *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
