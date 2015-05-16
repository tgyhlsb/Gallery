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

@implementation SRDirectory (Serializer)

+ (NSString *)className {
    return @"SRDirectory";
}

+ (SRDirectory *)directoryWithPath:(NSString *)path
                        attributes:(NSDictionary *)attributes
                             depth:(NSInteger)depth
                          provider:(NSString *)provider
            inManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self className]];
    request.predicate = [NSPredicate predicateWithFormat:@"path = %@", path];
    [request setReturnsObjectsAsFaults:NO];
    SRDirectory *directory = nil;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches || [matches count] > 1) {
        //handle error
    } else {
        if ([matches count]) {
            directory = [matches firstObject];
            [directory updateWithAttributes:attributes];
            NSLog(@"Fetched directory");
        } else {
            directory = [NSEntityDescription insertNewObjectForEntityForName:[self className] inManagedObjectContext:context];
            NSLog(@"Created directory");
            directory.provider = provider;
            [directory initializeWithPath:path attributes:attributes depth:depth];
        }
    }
    
    return directory;
}

@end
