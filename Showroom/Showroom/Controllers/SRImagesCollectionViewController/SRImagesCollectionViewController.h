//
//  SRImagesCollectionViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "UICoreDataCollectionViewController.h"

// Model
#import "SRModel.h"

@interface SRImagesCollectionViewController : UICoreDataCollectionViewController

+ (instancetype)newWithDirectory:(SRDirectory *)directory;

@end
