//
//  GADirectoryNavigationController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controllers
#import "GADirectoryInspectorVC.h"

// Models
#import "GADirectory.h"
#import "GAImageFile.h"

@protocol GADirectoryNavigationDelegate;

@interface GADirectoryNavigationController : UINavigationController <GADirectoryInspectorDelegate>

@property (weak, nonatomic) id<GADirectoryNavigationDelegate> directoryDelegate;

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory;

@end

@protocol GADirectoryNavigationDelegate <NSObject>

- (void)directoryInspector:(GADirectoryInspectorVC *)inspectorVC didSelectImageFile:(GAImageFile *)imageFile;

@end
