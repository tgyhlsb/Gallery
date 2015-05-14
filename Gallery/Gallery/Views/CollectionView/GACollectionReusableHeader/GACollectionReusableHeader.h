//
//  GACollectionReusableHeader.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//
#import "GACollectionReusableView.h"

// Models
#import "GADirectory.h"

@interface GACollectionReusableHeader : GACollectionReusableView

@property (strong, nonatomic) GADirectory *directory;

@end
