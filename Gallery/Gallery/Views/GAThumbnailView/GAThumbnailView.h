//
//  GAThumbnailView.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 05/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GAFile.h"

@interface GAThumbnailView : UIImageView

@property (strong, nonatomic) GAFile *file;
@property (nonatomic) CGFloat scale;

@end
