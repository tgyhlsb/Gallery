//
//  SRViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 11/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRViewController.h"

@implementation SRViewController

- (void)setTitleWithAppIcon {
    
    UIImage *image = [UIImage imageNamed:@"banner.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 300, 44);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
    self.title = @"";
}

@end
