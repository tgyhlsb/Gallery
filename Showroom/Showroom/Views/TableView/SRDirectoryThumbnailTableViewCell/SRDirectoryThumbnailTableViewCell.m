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
    
    [self.layer shouldRasterize];
}

@end
