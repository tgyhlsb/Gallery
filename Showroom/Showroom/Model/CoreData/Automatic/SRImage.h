//
//  SRImage.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SRFile.h"

@class SRDirectory;

@interface SRImage : SRFile

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) SRDirectory *directory;

@end
