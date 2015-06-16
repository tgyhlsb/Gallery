//
//  SRDirectoryThumbnailTableViewCell.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 13/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRDirectoryThumbnailTableViewCell.h"

@implementation SRDirectoryThumbnailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.thumbnailView.clipsToBounds = YES;
    self.thumbnailView.backgroundColor = [UIColor colorWithRed:0.47f green:0.67f blue:0.79f alpha:1.00f];
    
    [self.layer shouldRasterize];
}

@end
