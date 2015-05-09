//
//  GAFileLoadingVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GADirectory;

// Blocks
typedef void (^GAFileLoadingCompletionBlock)();

@interface GAFileLoadingVC : UIViewController

@property (strong, nonatomic) GAFileLoadingCompletionBlock completionBLock;

@end
