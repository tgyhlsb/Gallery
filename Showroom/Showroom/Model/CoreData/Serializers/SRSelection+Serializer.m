//
//  SRSelection+Serializer.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelection+Serializer.h"

@implementation SRSelection (Serializer)

+ (NSString *)className {
    return @"SRSelection";
}

+ (SRSelection *)selectionWithTitle:(NSString *)title
     inManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self className]];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    SRSelection *selection = nil;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches || [matches count] > 1) {
        //handle error
    } else {
        if ([matches count]) {
            selection = [matches firstObject];
            NSLog(@"Fetched selection");
        } else {
            selection = [NSEntityDescription insertNewObjectForEntityForName:[self className] inManagedObjectContext:context];
            selection.title = title;
            selection.creationDate = [NSDate date];
            NSLog(@"Created selection");
        }
        selection.modificationDate = [NSDate date];
    }
    
    return selection;
}

@end
