//
//  GAImageFileTableViewCell.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 05/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GATableViewCell.h"

// Models
#import "GAFile.h"

@interface GAImageFileTableViewCell : GATableViewCell

@property (strong, nonatomic) GAFile *imageFile;

@end
