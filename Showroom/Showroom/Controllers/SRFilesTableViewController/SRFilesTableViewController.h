//
//  SRFilesTableViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "UICoreDataTableViewController.h"

// Models
#import "SRModel.h"

@protocol SRFilesTableViewControllerDelegate;

@interface SRFilesTableViewController : UICoreDataTableViewController

@property (weak, nonatomic) id<SRFilesTableViewControllerDelegate> delegate;

+ (instancetype)newWithDirectory:(SRDirectory *)directory;

@end


@protocol SRFilesTableViewControllerDelegate <NSObject>

- (void)filesTableViewController:(SRFilesTableViewController *)controller didSelectImage:(SRImage *)image;
- (void)filesTableViewController:(SRFilesTableViewController *)controller didSelectDirectory:(SRDirectory *)directory;

@end