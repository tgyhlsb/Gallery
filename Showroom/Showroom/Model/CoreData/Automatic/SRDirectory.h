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

@class SRDirectory, SRImage;

@interface SRDirectory : SRFile

@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) SRDirectory *parentDirectory;
@property (nonatomic, retain) NSSet *subDirectories;
@end

@interface SRDirectory (CoreDataGeneratedAccessors)

- (void)addImagesObject:(SRImage *)value;
- (void)removeImagesObject:(SRImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addSubDirectoriesObject:(SRDirectory *)value;
- (void)removeSubDirectoriesObject:(SRDirectory *)value;
- (void)addSubDirectories:(NSSet *)values;
- (void)removeSubDirectories:(NSSet *)values;

@end
