//
//  SROperationProviderLocalSynchronization.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRDirectory;

@interface SROperationProviderLocalSynchronization : NSOperation

@property (readonly, strong, nonatomic) NSManagedObjectContext *parentManagedObjectContext;

@property (readwrite, nonatomic) BOOL recursively;
@property (readwrite, strong, nonatomic) SRDirectory *directory;

- (id)initWithParentManagedObjectContext:(NSManagedObjectContext *)parentManagedObjectContext;

@end
