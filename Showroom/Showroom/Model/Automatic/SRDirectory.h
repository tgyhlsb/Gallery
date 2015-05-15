//
//  SRDirectory.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRDirectory, SRImage;

@interface SRDirectory : NSManagedObject

@property (nonatomic, retain) NSSet *subDirectories;
@property (nonatomic, retain) SRDirectory *parentDirectory;
@property (nonatomic, retain) SRImage *images;
@end

@interface SRDirectory (CoreDataGeneratedAccessors)

- (void)addSubDirectoriesObject:(SRDirectory *)value;
- (void)removeSubDirectoriesObject:(SRDirectory *)value;
- (void)addSubDirectories:(NSSet *)values;
- (void)removeSubDirectories:(NSSet *)values;

@end
