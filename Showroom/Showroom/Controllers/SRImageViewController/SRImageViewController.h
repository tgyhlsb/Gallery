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

@protocol SRImageViewControllerDelegate;

@interface SRImageViewController : UIViewController

@property (weak, nonatomic) id<SRImageViewControllerDelegate> delegate;
@property (strong, nonatomic) SRImage *image;

+ (instancetype)newWithImage:(SRImage *)image;

- (void)hideTitleButtonAfter:(NSTimeInterval)delay;

@end

@protocol SRImageViewControllerDelegate <NSObject>

- (void)imageViewControllerDidSingleTap;
- (void)imageViewControllerDidDoubleTap;

@end