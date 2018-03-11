//
//  SRDirectoryThumbnailTableViewCell.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 13/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRTableViewCell.h"

@interface SRDirectoryThumbnailTableViewCell : SRTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
