//
//  SRFile+Serializer.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRFile+Serializer.h"

@implementation SRFile (Serializer)

+ (NSString *)className {
    return @"SRFile";
}

#define ATTRIBUTE_KEY_CREATIONDATE @"NSFileCreationDate"
#define ATTRIBUTE_KEY_MODIFICATIONDATE @"NSFileModificationDate"
#define ATTRIBUTE_KEY_SIZE @"NSFileSize"

- (void)updateWithPath:(NSString *)path attributes:(NSDictionary *)attributes depth:(NSInteger)depth {
    
    self.creationDate = [attributes objectForKey:ATTRIBUTE_KEY_CREATIONDATE];
    self.modificationDate = [attributes objectForKey:ATTRIBUTE_KEY_MODIFICATIONDATE];
    self.size = [attributes objectForKey:ATTRIBUTE_KEY_SIZE];
    
    self.path = path;
    self.name = [[path lastPathComponent] stringByDeletingPathExtension];
    self.extension = [path pathExtension];
    self.depth = @(depth);
}

@end
