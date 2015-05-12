//
//  GAImageCollectionViewCell.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//
#import "GACollectionViewCell.h"

// Models
#import "GAImageFile.h"

@interface GAImageCollectionViewCell : GACollectionViewCell

@property (strong, nonatomic) GAImageFile *imageFile;

@end
