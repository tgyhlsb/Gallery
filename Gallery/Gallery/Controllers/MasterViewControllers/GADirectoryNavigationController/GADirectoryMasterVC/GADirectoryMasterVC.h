//
//  GADirectoryInspectorVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GADirectory.h"
#import "GAImageFile.h"

@protocol GADirectoryViewControllerDelegate;

@interface GADirectoryMasterVC : UITableViewController

@property (weak, nonatomic) id<GADirectoryViewControllerDelegate> delegate;

@property (strong, nonatomic) GADirectory *directory;

+ (instancetype)newWithDirectory:(GADirectory *)directory;

@end

@protocol GADirectoryViewControllerDelegate <NSObject>

- (void)directoryViewController:(GADirectoryMasterVC *)controller didSelectFile:(GAFile *)file;

@end