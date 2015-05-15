//
//  SRFile.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SRFile : NSManagedObject

@property (nonatomic, retain) NSString * extension;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * provider;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * modificationDate;
@property (nonatomic, retain) NSNumber * size;

@end
