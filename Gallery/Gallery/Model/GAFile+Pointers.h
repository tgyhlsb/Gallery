//
//  GAFile+Pointers.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFile.h"

#import "GAImageFile.h"
#import "GADirectory.h"

@interface GAFile (Pointers)

- (GAImageFile *)nextImage;
- (GAImageFile *)previousImage;

- (GADirectory *)nextDirectory;
- (GADirectory *)previousDirectory;

@end
