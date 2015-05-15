//
//  SRDirectory+Serializer.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRDirectory+Serializer.h"

// Serializers
#import "SRFile+Serializer.h"

#define CLASS_NAME_SRDIRECTORY @"SRDirectory"

@implementation SRDirectory (Serializer)

+ (SRDirectory *)directoryWithPath:(NSString *)path
                        attributes:(NSDictionary *)attributes
                          provider:(NSString *)provider
            inManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CLASS_NAME_SRDIRECTORY];
    request.predicate = [NSPredicate predicateWithFormat:@"path = %@", path];
    SRDirectory *directory = nil;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches || [matches count] > 1) {
        //handle error
    } else {
        if ([matches count]) {
            directory = [matches firstObject];
        } else {
            directory = [NSEntityDescription insertNewObjectForEntityForName:CLASS_NAME_SRDIRECTORY inManagedObjectContext:context];
        }
        
        //TODO attributes
        directory.provider = provider;
        [directory updateWithPath:path attributes:attributes];
    }
    
    return directory;
}

@end
