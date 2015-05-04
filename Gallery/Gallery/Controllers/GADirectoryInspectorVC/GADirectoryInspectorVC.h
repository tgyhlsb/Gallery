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

@protocol GADirectoryInspectorDelegate;

@interface GADirectoryInspectorVC : UITableViewController

@property (strong, nonatomic) GADirectory *directory;
@property (weak, nonatomic) id<GADirectoryInspectorDelegate> delegate;

+ (instancetype)newWithDirectory:(GADirectory *)directory;

@end

@protocol GADirectoryInspectorDelegate <NSObject>

- (void)directoryInspector:(GADirectoryInspectorVC *)inspectorVC didSelectImageFile:(GAImageFile *)imageFile;

@end