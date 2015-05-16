//
//  SRImageViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "SRImage.h"

@interface SRImageViewController : UIViewController

@property (strong, nonatomic) SRImage *image;

+ (instancetype)newWithImage:(SRImage *)image;

@end