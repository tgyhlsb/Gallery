//
//  GAFileInspectorVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GAFile+Pointers.h"

// Managers
#import "GALogger.h"

@interface GAFileInspectorVC : UIViewController

@property (strong, nonatomic) GAFile *file;

+ (GAFileInspectorVC *)inspectorForFile:(GAFile *)file;

- (void)updateViewWithFile:(GAFile *)file;

@end
