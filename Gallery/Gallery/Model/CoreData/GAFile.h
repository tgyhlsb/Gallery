//
//  GAFile.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GAFile : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;

@end
