//
//  SRDiaporamaCollectionViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "UICoreDataCollectionViewController.h"

// Model
#import "SRModel.h"

@interface SRDiaporamaCollectionViewController : UICoreDataCollectionViewController

+ (instancetype)newWithDirectory:(SRDirectory *)directory selectedImage:(SRImage *)selectedImage;

@end
